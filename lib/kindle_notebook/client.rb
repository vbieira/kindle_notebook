# frozen_string_literal: true

module KindleNotebook
  class Client
    attr_reader :books

    def initialize(session)
      @session = session
      @books = fetch_books
    end

    private

    attr_reader :session
    attr_writer :books

    def fetch_books
      session.find("ul#cover").all("li").map do |element|
        Book.new(element.find("div", id: /author-/).text,
                 element.find("div", id: /title-/).text,
                 session)
      end
    end
  end
end
