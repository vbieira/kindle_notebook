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
          Book.new(element.find("div", id: /author-/).text,
                   element.find("div", id: /title-/).text)
        end
      end
    end
  end
end
