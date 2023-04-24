# frozen_string_literal: true

module KindleNotebook
  module Helpers
    def self.to_csv(arr, file_name = "output.csv")
      headers = arr.first.keys
      r = CSV.generate do |csv|
        csv << headers
        arr.each { |x| csv << x.values }
      end
      File.write(file_name, r)
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
