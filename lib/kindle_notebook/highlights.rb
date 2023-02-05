# frozen_string_literal: true

module KindleNotebook
  class Highlights
    attr_reader :highlights

    WORDS_LIMIT = 3

    def initialize(session = AmazonAuth.new.sign_in)
      @session = session
      @highlights = []
    end

    def fetch_all
      session.find("#cover").find("li", match: :first).find("a").click # TODO: iterate books
      open_notebook
      items = highlight_items
      open_search
      sleep 1
      items.each { |item| fetch(item[:text], item[:page]) }
      highlights
    end

    private

    attr_reader :session
    attr_writer :highlights

    def highlight_items
      content = session.find("div", class: "notebook-content").all("ion-item")
      puts "#{content.count} highlights in this book"
      parsed = content.map do |item|
        { text: item.find(".notebook-editable-item-black").text,
          page: item.find(".notebook-editable-item-grey").text.split(" ").last }
      end
      close_notebook
      parsed
    end

    def open_notebook
      show_toolbar
      session.first(:xpath, '//ion-button[@item-i-d="top_menu_notebook"]').click
    end

    def close_notebook
      session.find("#notebook-header-close-img").click
    end

    def fetch(text, page)
      puts "fetching #{text} from page #{page}..."
      parsed_text = parse_text(text)
      return if parsed_text.split(" ").count > WORDS_LIMIT

      context = search_highlight(text, page)
      highlights.push(text: parsed_text, page: page, context: context)
    end

    def open_search
      show_toolbar
      session.first(:xpath, '//ion-button[@item-i-d="top_menu_search"]').click
    end

    def show_toolbar
      session.find("div", class: "fixed-book-title", wait: 5).hover
    end

    def parse_text(text)
      text.gsub("...", "")
    end

    def search_highlight(text, page)
      session.find("input", class: "searchbar-input").set(text)
      sleep 3 # wait for search response
      context = nil
      if session.has_css?(".search-results")
        context = get_context(page)
      else
        puts "no search results for #{text}"
      end
      clear_search
      context
    end

    def search_results
      session.find(".search-results", wait: 5).all(".search-item")
    end

    def get_context(page)
      page_result = search_results.find { |r| r.find(".search-item-label").text.split(" ").last == page }
      page_result.find(".search-item-context").text
    end

    def clear_search
      session.find("input", class: "searchbar-input").set("")
      sleep 1
    end
  end
end
