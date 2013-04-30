# Webshot

Captures a web page as a screenshot using Poltergeist, Capybara and [PhantomJS](http://phantomjs.org/)

## Installation

Download and install PhantomJS and then add PhantomJS to
your PATH. Add this line to your application's Gemfile:

    gem "webshot"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install webshot

## Usage

    # Setup Capybara
    Webshot.capybara_setup!

    webshot = Webshot::Screenshot.new
    webshot.capture "http://www.google.com/", "google.png"

    # Customize output (MiniMagick settings)
    webshot.capture "http://www.google.com/", "google.png", width: 100, height: 90, quality: 85

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
