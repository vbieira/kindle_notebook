# frozen_string_literal: true

module KindleNotebook
  class Configuration
    attr_accessor :url, :login, :password, :driver

    def initialize
      @url = "https://read.amazon.com/"
      @driver = "firefox"
    end
  end
end
