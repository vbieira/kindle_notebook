# frozen_string_literal: true

module KindleNotebook
  class Book
    attr_reader :author, :title, :session

    def initialize(author, title, session)
      @author = author
      @title = title
      @highlights = nil
      @session = session
    end

    def highlights
      @highlights ||= Highlights.new(session).fetch
    end

    def open
      puts "Opening \"#{title}\""
      session.visit(ENV["KINDLE_READER_URL"]) unless session.has_selector?("p", text: title)
      session.find("p", text: title).click
    end
  end
end
