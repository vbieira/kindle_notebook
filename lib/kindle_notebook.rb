# frozen_string_literal: true

require "capybara"
require "capybara/sessionkeeper"
require "dotenv"
require "csv"

require_relative "kindle_notebook/amazon_auth"
require_relative "kindle_notebook/book"
require_relative "kindle_notebook/client"
require_relative "kindle_notebook/configuration"
require_relative "kindle_notebook/helpers"
require_relative "kindle_notebook/highlights"
require_relative "kindle_notebook/highlight"
require_relative "kindle_notebook/version"

Dotenv.load

module KindleNotebook
  class Error < StandardError; end

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.register_driver :firefox do |app|
    Capybara::Selenium::Driver.new(app, browser: :firefox)
  end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def session
      @session ||= AmazonAuth.new.sign_in
    end
  end
end
