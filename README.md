# Webshot

Captures a web page as a screenshot using Poltergeist, Capybara and PhantomJS.

  - [![Build Status](https://travis-ci.org/vitalie/webshot.svg?branch=master)](https://travis-ci.org/vitalie/webshot)

## Installation

Download and install [PhantomJS](http://phantomjs.org/releases.html) version 2.X,
add the directory containing the binary to your PATH.

Add the `webshot` gem to your Gemfile:

    gem "webshot"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install webshot

## Usage

```rb
# Setup Capybara
ws = Webshot::Screenshot.instance

# Capture Google's home page
ws.capture "http://www.google.com/", "google.png"

# Customize thumbnail
ws.capture "http://www.google.com/", "google.png", width: 100, height: 90, quality: 85

# Specify only width, height will be computed according to page's height
ws.capture "http://www.google.com/", "google.png", width: 1024

# Specify an array of additional HTTP status codes to accept,
# beyond normal success codes like 200 or 302
ws.capture "http://www.google.com/foo", "google_404.png", allowed_status_codes: [404]

# Customize thumbnail generation (MiniMagick)
# see: https://github.com/minimagick/minimagick
ws.capture("http://www.google.com/", "google.png") do |magick|
  magick.combine_options do |c|
    c.thumbnail "100x"
    c.background "white"
    c.extent "100x90"
    c.gravity "north"
    c.quality 85
  end
end

```

You can wait some time after visit page before capturing screenshot.

```rb
# Timeout in seconds
ws.capture 'http://www.google.com/', 'google.png', timeout: 2

```

You can login before capturing screenshot.

```rb
ws.start_session do
  visit 'https://github.com/login'
  fill_in 'Username or Email', :with => 'user@example.com'
  fill_in 'Password', :with => 'password'
  click_button 'Sign in'
end.capture 'https://github.com/username/', 'github.png'

```

## Scaling

It's not recommended to start multiple PhantomJS concurrently.
You should serialize requests, treat the process as unreliable and
monitor it with daemontools, god, monit, etc.

Recommended setup:

     [S3] <-- [CloudFront + 404 handler] <-- User Request
      ^
      |
    Worker <--> [Queue] <-- App


The application triggers screenshot requests which are queued and
then processed by a background worker ([Resque](https://github.com/resque/resque), [Sidekiq](https://github.com/mperham/sidekiq), etc).
The worker uploads the images to S3 which are served through
CloudFront. The CDN should be configured to serve a default
image (404 handler) with a low TTL to handle screenshot are not
yet ready or couldn't be generated.

Notes:
  - sed 's/S3/Your file hosting service/g'
  - sed 's/CloudFront/Your CDN service/g'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
