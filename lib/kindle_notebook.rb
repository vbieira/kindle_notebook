# frozen_string_literal: true

require "capybara"
require "capybara/sessionkeeper"
require "dotenv"
require "csv"

require_relative "kindle_notebook/amazon_auth"
require_relative "kindle_notebook/book"
require_relative "kindle_notebook/client"
require_relative "kindle_notebook/highlights"
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

  def self.to_csv(arr, file_name = "output.csv")
    headers = arr.first.keys
    r = CSV.generate do |csv|
      csv << headers
      arr.each { |x| csv << x.values }
    end
    File.write(file_name, r)
    file_name
  end
end
