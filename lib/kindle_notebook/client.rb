# frozen_string_literal: true

module KindleNotebook
  module Client
    class << self
      def books
        @books ||= fetch_books
      end

      private

      def fetch_books
        KindleNotebook.session.find("ul#cover").all("li").map do |element|
          Book.new(author: element.find("div", id: /author-/).text,
                   title: element.find("div", id: /title-/).text,
                   asin: element.find("div", match: :first)["data-asin"])
        end
      end
    end
  end
end
