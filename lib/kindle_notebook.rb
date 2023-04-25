# frozen_string_literal: true

require "capybara"
require "capybara/sessionkeeper"
require "dotenv"
require "csv"
require "selenium-webdriver"

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
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless") if configuration.headless
    options.add_argument("--disable-gpu")
    options.add_argument("--no-sandbox")

    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  Capybara.register_driver :firefox do |app|
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument("--headless") if configuration.headless

    Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
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
