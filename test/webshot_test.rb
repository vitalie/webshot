require "test_helper"

class WebshotTest < Test::Unit::TestCase

  DATA_DIR = File.expand_path(File.dirname(__FILE__) + "/data")

  def setup
    Webshot.capybara_setup!
    @webshot = Webshot::Screenshot.new
  end

  def test_http
    assert_nothing_raised do
      %w(www.google.com www.yahoo.com).each do |name|
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

  def test_
    %w(888.888.888.888).each do |name|
      assert_raise Webshot::WebshotError do
        @webshot.capture "http://#{name}/", thumb(name)
      end
    end
  end

  protected

  def thumb(name)
    File.join(DATA_DIR, "#{name}.png")
  end
end
