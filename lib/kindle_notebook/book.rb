# frozen_string_literal: true

module KindleNotebook
  class Book
    attr_reader :author, :title

    def initialize(author, title)
      @author = author
      @title = title
      @highlights = nil
    end

    def highlights
      @highlights ||= Highlights.new(session).fetch
    end

    def open
      session.visit(ENV["KINDLE_READER_URL"]) unless session.has_selector?("p", text: title)
      session.find("p", text: title).click
    end

    private

    def session
      Client.session
    end
  end
end
