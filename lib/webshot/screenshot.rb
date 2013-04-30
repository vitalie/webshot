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
      # Default settings
      width   = opts.fetch(:width, 120)
      height  = opts.fetch(:height, 90)
      gravity = opts.fetch(:gravity, "north")
      quality = opts.fetch(:quality, 85)

      # Open page
      visit url

      if page.driver.status_code == 200
        # Save screenshot
        page.driver.save_screenshot(path, :full => true)

        # Resize screenshot
        thumb = MiniMagick::Image.open(path)
        thumb.combine_options do |c|
          c.thumbnail "#{width}x"
          c.background "white"
          c.extent "#{width}x#{height}"
          c.gravity gravity
          c.quality quality
        end

        # Save thumbnail
        thumb.write path
      else
        raise WebshotError.new("Could not fetch page: #{url.inspect}, error code: #{page.driver.status_code}")
      end
    end
  end
end
