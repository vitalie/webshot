require "test_helper"

class WebshotTest < Test::Unit::TestCase

  DATA_DIR = File.expand_path(File.dirname(__FILE__) + "/data")

  def setup
    Webshot.capybara_setup!
    @webshot = Webshot::Screenshot.new
  end

  def test_http
    assert_nothing_raised do
      %w(www.yahoo.com).each do |name|
        output = thumb(name)
        File.delete output if File.exists? output
        @webshot.capture "http://#{name}/", output
        assert File.exists? output
      end
    end
  end

  def test_https
    assert_nothing_raised do
      %w(github.com).each do |name|
        output = thumb(name)
        File.delete output if File.exists? output
        @webshot.capture "https://#{name}/", output
        assert File.exists? output
      end
    end
  end

  def test_invalid_url
    %w(nxdomain).each do |name|
      assert_raise Webshot::WebshotError do
        @webshot.capture "http://#{name}/", thumb(name)
      end
    end
  end

  def test_mini_magick
    assert_nothing_raised do
      %w(www.yahoo.com).each do |name|
        output = thumb(name)
        File.delete output if File.exists? output

        # Customize MiniMagick options
        result = @webshot.capture("http://#{name}/", output) do |thumb|
          thumb.combine_options do |c|
            c.thumbnail "100x90"
          end
        end
        assert File.exists? output
        assert result.respond_to? :to_blob
      end
    end
  end

  protected

  def thumb(name)
    File.join(DATA_DIR, "#{name}.png")
  end
end
