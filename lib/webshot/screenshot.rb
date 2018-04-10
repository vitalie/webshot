require "singleton"

module Webshot
  class Screenshot
    include Capybara::DSL
    include Singleton

    def initialize(opts = {})
      Webshot.capybara_setup!
      width  = opts.fetch(:width, Webshot.width)
      height = opts.fetch(:height, Webshot.height)
      user_agent = opts.fetch(:user_agent, Webshot.user_agent)

      # Browser settings
      page.driver.resize(width, height)
      page.driver.headers = {
        "User-Agent" => user_agent
      }
    end

    def start_session(&block)
      Capybara.reset_sessions!
      Capybara.current_session.instance_eval(&block) if block_given?
      @session_started = true
      self
    end

    def valid_status_code?(status_code, allowed_status_codes)
      return true if status_code == 200
      return true if status_code / 100 == 3
      return true if allowed_status_codes.include?(status_code)
      false
    end

    # Captures a screenshot of +url+ saving it to +path+.
    def capture(url, path, opts = {})
      begin
        # Default settings
        width   = opts.fetch(:width, 120)
        height  = opts.fetch(:height, 90)
        gravity = opts.fetch(:gravity, "north")
        quality = opts.fetch(:quality, 85)
        full = opts.fetch(:full, true)
        selector = opts.fetch(:selector, nil)
        allowed_status_codes = opts.fetch(:allowed_status_codes, [])

        # Reset session before visiting url
        Capybara.reset_sessions! unless @session_started
        @session_started = false

        # Open page
        visit url

        # Timeout
        sleep opts[:timeout] if opts[:timeout]

        # Check response code
        status_code = page.driver.status_code.to_i
        unless valid_status_code?(status_code, allowed_status_codes)
          fail WebshotError, "Could not fetch page: #{url.inspect}, error code: #{page.driver.status_code}"
        end

        tmp = Tempfile.new(["webshot", ".png"])
        tmp.close
        begin
          screenshot_opts = selector ? { selector: selector } : { full: full }

          # Save screenshot to file
          page.driver.save_screenshot(tmp.path, screenshot_opts)

          # Resize screenshot
          thumb = MiniMagick::Image.open(tmp.path)
          if block_given?
            # Customize MiniMagick options
            yield thumb
          else
            thumb.combine_options do |c|
              c.thumbnail "#{width}x"
              c.background "white"
              c.extent "#{width}x#{height}"
              c.gravity gravity
              c.quality quality
            end
          end

          # Save thumbnail
          thumb.write path
          thumb
        ensure
          tmp.unlink
        end
      rescue Capybara::Poltergeist::StatusFailError, Capybara::Poltergeist::BrowserError, Capybara::Poltergeist::DeadClient, Capybara::Poltergeist::TimeoutError, Errno::EPIPE => e
        # TODO: Handle Errno::EPIPE and Errno::ECONNRESET
        raise WebshotError.new("Capybara error: #{e.message.inspect}")
      end
    end
  end
end
