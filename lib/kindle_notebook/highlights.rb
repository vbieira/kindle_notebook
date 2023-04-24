# frozen_string_literal: true

module KindleNotebook
  class Highlights
    attr_accessor :book

    # Range of acceptable word counts for a highlight
    MIN_HIGHLIGHT_WORDS = 1
    MAX_HIGHLIGHT_WORDS = 3

    def initialize(book)
      @book = book
    end

    def fetch
      open_notebook
      add_highlights
      book.highlights
    end

    private

    def session
      KindleNotebook.session
    end

    def add_highlights
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
      session.first(:xpath, '//ion-button[@item-i-d="top_menu_notebook"]', wait: 5).click
    end

    def close_notebook
      session.find("#notebook-header-close-img").click
    end

    def fetch_highlights_with_context(items)
      items.each_with_index do |item, index|
        parsed_text = Helpers.clean_up_text(item[:text])
        page = item[:page]
        puts "[#{index + 1}/#{book.highlights_count}] \"#{parsed_text}\" page #{page}... "
        next unless within_range?(parsed_text)

        add_highlight(parsed_text, page, item[:text])
      end
    end

    def within_range?(text)
      (MIN_HIGHLIGHT_WORDS..MAX_HIGHLIGHT_WORDS).include?(text.split(" ").count)
    end

    def add_highlight(text, page, raw_text)
      context, raw_context = search_highlight_context(text, page)
      new_highlight = Highlight.new(text: text,
                                    page: page,
                                    context: context,
                                    book_asin: book.asin,
                                    raw_text: raw_text,
                                    raw_context: raw_context)
      book.highlights.push(new_highlight)
    end

    def open_search
      show_toolbar
      session.first(:xpath, '//ion-button[@item-i-d="top_menu_search"]', wait: 2).click
    end

    def show_toolbar
      session.first(:xpath, "//ion-header", wait: 2).hover
    end

    def search_highlight_context(text, page)
      search_highlight(text)
      context = nil
      raw_context = nil
      context, raw_context = context_from_element(text, page) if session.has_css?(".search-results")
      clear_search
      [context, raw_context]
    end

    def search_highlight(text)
      session.find("input", class: "searchbar-input").set(text)
      sleep 1 while session.has_css?(".kg-loader") # wait for search response
    end

    def search_results
      session.find(".search-results", wait: 5).all(".search-item")
    end

    def context_from_element(text, page)
      page_result = search_results.find { |r| r.find(".search-item-label").text.split(" ").last == page }
      if page_result.nil?
        puts "no context for #{text}"
        return ["", ""]
      end

      context = page_result.find(".search-item-context").text
      [Helpers.sentence_with_word(context, text), context]
    end

    def clear_search
      session.find("input", class: "searchbar-input").set("")
      sleep 1
    end
  end
end
