# frozen_string_literal: true

module KindleNotebook
  class Configuration
    attr_accessor :url, :login, :password, :selenium_driver, :headless_mode, :min_highlight_words, :max_highlight_words
  end
end
