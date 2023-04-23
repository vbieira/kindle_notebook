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
  end
end
