module Webshot
  class Screenshot
    include Capybara::DSL

    def initialize(opts = {})
      width  = opts.fetch(:width, Webshot.width)
      height = opts.fetch(:height, Webshot.height)
      user_agent = opts.fetch(:user_agent, Webshot.user_agent)
      page.driver.resize(width, height)
      page.driver.headers = {
        "User-Agent" => user_agent,
      }
    end

    def capture(url, path, opts = {})
      # Default settings
      width   = opts.fetch(:width, 120)
      height  = opts.fetch(:height, 90)
      gravity = opts.fetch(:gravity, "north")
      quality = opts.fetch(:quality, 85)

      visit url
      if page.driver.status_code == 200
        page.driver.save_screenshot(path, :full => true)
        thumb = MiniMagick::Image.open(path)
        thumb.combine_options do |c|
          c.thumbnail "#{width}x"
          c.background "white"
          c.extent "#{width}x#{height}"
          c.gravity "north"
          c.quality 85
        end
        thumb.write path
      else
        raise WebshotError.new("Could not fetch page: #{url.inspect}")
      end
    end
  end
end
