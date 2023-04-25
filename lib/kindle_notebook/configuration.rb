# frozen_string_literal: true

module KindleNotebook
  class Configuration
    attr_accessor :url, :login, :password, :driver, :headless

    def initialize
      @url = "https://read.amazon.com/"
      @driver = "firefox"
      @headless = true
    end
  end
end
