# frozen_string_literal: true

module KindleNotebook
  module Helpers
    def self.to_csv_file(headers, list, file_name = "output.csv")
      full_csv = ""
      full_csv += CSV.generate_line(headers)
      list.each { |element| full_csv += element.to_csv }
      File.write(file_name, full_csv)
      file_name
    end

    def self.sentence_with_word(full_text, target_word)
      sentences = full_text.scan(/\s+[^.!?]*[.!?]/) # match sentences
      matching_sentence = sentences.select { |s| s.include?(target_word) }.first&.strip
      matching_sentence || full_text
    end

    def self.clean_up_text(text)
      text.downcase.gsub(/[^0-9a-zA-Z -]+/, "").strip
    end
  end
end
