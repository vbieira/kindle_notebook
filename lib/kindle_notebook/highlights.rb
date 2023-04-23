# frozen_string_literal: true

module KindleNotebook
  class Highlights
    attr_accessor :book

    # To only fetch highlights that have a word count within range
    MIN_WORDS = 1
    MAX_WORDS = 3

    Highlight = Struct.new(:text, :page, :context)

    def initialize(book)
      @book = book
    end

    def fetch
      open_notebook
      add_highlights
    end

    private

    def session
      KindleNotebook.session
    end

    def add_highlights
      # TODO: interrupt and still have highlights
      items = notebook_highlights
      close_notebook
      open_search
      fetch_highlights_with_context(items)
    end

    # fetch all highlights (without context) from notebook
    def notebook_highlights
      content = session.find("div", class: "notebook-content").all("ion-item")
      puts "#{content.count} highlights in this book \n"
      book.highlights_count = content.count
      content.map { |h| parse_notebook_highlight(h) }
    end

    def parse_notebook_highlight(item)
      { text: item.find(".notebook-editable-item-black").text,
        page: item.find(".notebook-editable-item-grey").text.split(" ").last }
    end

    def open_notebook
      show_toolbar
      session.first(:xpath, '//ion-button[@item-i-d="top_menu_notebook"]').click
    end

    def close_notebook
      session.find("#notebook-header-close-img").click
    end

    def fetch_highlights_with_context(items)
      items.each_with_index do |item, index|
        parsed_text = parse_text(item[:text])
        page = item[:page]
        puts "[#{index + 1}/#{book.highlights_count}] \"#{parsed_text}\" page #{page}... "
        next unless (MIN_WORDS..MAX_WORDS).include?(parsed_text.split(" ").count)

        add_highlight(parsed_text, page)
      end
    end

    def add_highlight(text, page)
      context = search_highlight(text, page)
      book.highlights.push(Highlight.new(text: text, page: page, context: context))
    end

    def open_search
      show_toolbar
      session.first(:xpath, '//ion-button[@item-i-d="top_menu_search"]').click
      sleep 1
    end

    def show_toolbar
      session.find("div", match: :first).hover
    end

    def parse_text(text)
      text.downcase.gsub(/[^0-9a-zA-Z -]+/, "").strip
    end

    def search_highlight(text, page)
      session.find("input", class: "searchbar-input").set(text)
      sleep 1 while session.has_css?(".kg-loader") # wait for search response
      context = nil
      if session.has_css?(".search-results")
        context = get_context(text, page)
      else
        puts "no search results for #{text}"
      end
      clear_search
      context
    end

    def search_results
      session.find(".search-results", wait: 5).all(".search-item")
    end

    def get_context(text, page)
      page_result = search_results.find { |r| r.find(".search-item-label").text.split(" ").last == page }
      if page_result.nil?
        puts "no context for #{text}"
        return ""
      end

      context = page_result.find(".search-item-context").text
      parse_context(text, context)
    end

    def parse_context(text, context)
      sentences = context.scan(/\s+[^.!?]*[.!?]/) # match sentences
      sentences.select { |s| s.include?(text) }.first&.strip || context
    end

    def clear_search
      session.find("input", class: "searchbar-input").set("")
      sleep 1
    end
  end
end
