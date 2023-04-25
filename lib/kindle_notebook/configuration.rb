# frozen_string_literal: true

module KindleNotebook
  class Configuration
    attr_accessor :url, :login, :password, :driver, :headless, :min_highlight_words, :max_highlight_words

    def initialize
      @url = "https://read.amazon.com/"
      @driver = "firefox"
      @headless = true
      # Filter out highlights with word counts outside range
      @min_highlight_words = 1
      @max_highlight_words = 3
    end
  end
end
