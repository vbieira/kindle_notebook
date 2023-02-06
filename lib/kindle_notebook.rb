# frozen_string_literal: true

require "capybara"
require "capybara/sessionkeeper"
require "dotenv"
require "csv"

require_relative "kindle_notebook/amazon_auth"
require_relative "kindle_notebook/highlights"
require_relative "kindle_notebook/version"

Dotenv.load

module KindleNotebook
  class Error < StandardError; end

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  def self.to_csv_file(arr)
    headers = arr.first.keys
    r = CSV.generate do |csv|
      csv << headers
      arr.each { |x| csv << x.values }
    end
    File.write("output.csv", r)
  end
end
