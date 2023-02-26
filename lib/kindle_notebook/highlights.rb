# frozen_string_literal: true

module KindleNotebook
  class Highlights
    attr_reader :highlights, :book

    # To only fetch highlights that have a word count within range
    MIN_WORDS = 1
    MAX_WORDS = 3

    Highlight = Struct.new(:text, :page, :context)

    def initialize(session)
      @session = session
      @highlights = []
    end

    def fetch
      open_notebook
      return [] unless highlights?

      add_highlights
      highlights
    end

    private

    attr_reader :session
    attr_writer :highlights

    def highlights?
      session.has_selector?("div", class: "notebook-content")
    end

    def add_highlights
      items, total = highlight_items
      close_notebook
      open_search
      items.each_with_index { |item, index| add_highlight(item[:text], item[:page], index, total) }
    end

    def highlight_items
      content = session.find("div", class: "notebook-content").all("ion-item")
      puts "#{content.count} highlights in this book \n"
      [content.map do |item|
        { text: item.find(".notebook-editable-item-black").text,
          page: item.find(".notebook-editable-item-grey").text.split(" ").last }
      end, content.count]
    end

    def open_notebook
      show_toolbar
      session.first(:xpath, '//ion-button[@item-i-d="top_menu_notebook"]').click
    end

    def close_notebook
      session.find("#notebook-header-close-img").click
    end

    def add_highlight(text, page, index, total)
      parsed_text = parse_text(text)
      puts "[#{index + 1}/#{total}] \"#{parsed_text}\" page #{page}... "
      return unless (MIN_WORDS..MAX_WORDS).include?(parsed_text.split(" ").count)

      context = search_highlight(text, page)
      highlights.push(Highlight.new(text: parsed_text, page: page, context: context))
    end

    def open_search
      show_toolbar
      session.first(:xpath, '//ion-button[@item-i-d="top_menu_search"]').click
      sleep 1
    end

    def show_toolbar
      session.find("div", class: "fixed-book-title", wait: 5).hover
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
