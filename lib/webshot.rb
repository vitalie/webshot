require "webshot/version"
require "active_support/core_ext"

module Webshot
  # Thumbnail width
  mattr_accessor :width
  @@width = 120

  # Thumbnail height
  mattr_accessor :height
  @@height = 90

  # Gravity
  mattr_accessor :gravity
  @@gravity = "north"

  # Default quality for thumbnails
  mattr_accessor :quality
  @@quality = 85

  def self.setup
    yield self
  end
end
