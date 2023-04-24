# frozen_string_literal: true

module KindleNotebook
  class Book
    attr_reader :author, :title, :asin
    attr_accessor :highlights_count, :highlights

    def initialize(book_attrs)
      @author = book_attrs[:author]
      @title = book_attrs[:title]
      @asin = book_attrs[:asin]
      @highlights_count = nil
      @highlights = []
    end

    def fetch_highlights
      open_book unless session.current_url.include?(asin)
      Highlights.new(self).fetch
    end

    def to_csv_file
      headers = highlights.first.attributes
      Helpers.to_csv_file(headers, highlights, "#{title} - #{author}.csv")
    end

    private

    def session
      KindleNotebook.session
    end

    def open_book
      session.visit(KindleNotebook.configuration.url) unless session.has_selector?("p", text: title)
      session.find("p", text: title).click
      sleep 3 # book might take a bit to load
    end
  end
end
