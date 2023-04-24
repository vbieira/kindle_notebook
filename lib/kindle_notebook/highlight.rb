# frozen_string_literal: true

module KindleNotebook
  class Highlight
    attr_reader :text, :page, :context, :book_asin, :raw_text, :raw_context

    def initialize(highlight_attrs)
      @text = highlight_attrs[:text]
      @page = highlight_attrs[:page]
      @context = highlight_attrs[:context]
      @book_asin = highlight_attrs[:book_asin]
      @raw_text = highlight_attrs[:raw_text]
      @raw_context = highlight_attrs[:raw_context]
    end

    def book
      @book ||= Client.books.find { |b| b.asin == book_asin }
    end
  end
end
