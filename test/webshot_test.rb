require "test_helper"

class WebshotTest < Minitest::Test
  DATA_DIR = File.expand_path(File.dirname(__FILE__) + "/data")

  def setup
    FileUtils.mkdir_p(DATA_DIR) unless File.directory?(DATA_DIR)
    @webshot = Webshot::Screenshot.instance
  end

  def test_http
    %w(www.yahoo.com).each do |name|
      output = thumb(name)
      File.delete output if File.exist? output
      @webshot.capture "http://#{name}/", output
      assert File.exist? output
    end
  end

  def test_https
    %w(github.com).each do |name|
      output = thumb(name)
      File.delete output if File.exist? output
      @webshot.capture "https://#{name}/", output
      assert File.exist? output
    end
  end

  def test_invalid_url
    %w(nxdomain).each do |name|
      assert_raises Webshot::WebshotError do
        @webshot.capture "http://#{name}/", thumb(name)
      end
    end
  end

  def test_mini_magick
    %w(www.yahoo.com).each do |name|
      output = thumb(name)
      File.delete output if File.exist? output

      # Customize MiniMagick options
      result = @webshot.capture("http://#{name}/", output) do |thumb|
        thumb.combine_options do |c|
          c.thumbnail "100x90"
        end
      end
      assert File.exist? output
      assert result.respond_to? :to_blob
    end
  end

  def test_allowed_404_status
    %w(en.wikipedia.org/wiki/THIS_PAGE_DOES_NOT_EXIST).each do |name|
      output = thumb('404_example')
      File.delete output if File.exist? output

      @webshot.capture "https://#{name}/", output, allowed_status_codes: [404]
      assert File.exist? output
    end
  end

  protected

  def thumb(name)
    File.join(DATA_DIR, "#{name}.png")
  end
end
