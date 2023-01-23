# frozen_string_literal: true

require "capybara"
require "capybara/sessionkeeper"
require "dotenv"

require_relative "kindle_notebook/amazon_auth"
require_relative "kindle_notebook/version"

Dotenv.load

module KindleNotebook
  class Error < StandardError; end

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end
end
