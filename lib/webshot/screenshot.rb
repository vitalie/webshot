module Webshot
  class Screenshot
    include Capybara::DSL

    def initialize(opts = {})
      width  = opts.fetch(:width, Webshot.width)
      height = opts.fetch(:height, Webshot.height)
      user_agent = opts.fetch(:user_agent, Webshot.user_agent)

      # Browser settings
      page.driver.resize(width, height)
      page.driver.headers = {
        "User-Agent" => user_agent,
      }
    end

    # Captures a screenshot of +url+ saving it to +path+.
    def capture(url, path, opts = {})
      begin
        # Default settings
        width   = opts.fetch(:width, 120)
        height  = opts.fetch(:height, 90)
        gravity = opts.fetch(:gravity, "north")
        quality = opts.fetch(:quality, 85)

        # Reset session before visiting url
        Capybara.reset_sessions!

        # Open page
        visit url

        # Check response code
        if page.driver.status_code == 200
          tmp = Tempfile.new(["webshot", ".png"])
          tmp.close
          begin
            # Save screenshot to file
            page.driver.save_screenshot(tmp.path, :full => true)

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
        else
          raise WebshotError.new("Could not fetch page: #{url.inspect}, error code: #{page.driver.status_code}")
        end
      rescue Capybara::Poltergeist::DeadClient, Capybara::Poltergeist::TimeoutError => e
        raise WebshotError.new("Capybara error: #{e.message.inspect}")
      end
    end
  end
end
