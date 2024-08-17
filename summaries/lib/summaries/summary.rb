# frozen_string_literal: true

require "uri"
require "net/http"
require "rss"

module Summaries
  class Summary
    attr_accessor :id

    def initialize id
      @id = id
    end

    def hostname
      ENV.fetch("SUMMARIES_HOSTNAME", "example.com")
    end

    def dir
      ENV.fetch("SUMMARIES_DIR", "rss")
    end

    def uri_string
      "https://#{hostname}/#{dir}/#{@id}.rdf"
    end

    def uri
      @uri ||= URI.parse(uri_string)
    end

    def body
      @body ||= Net::HTTP.get(uri)
    end

    def encoded_body
      body.force_encoding(Encoding::UTF_8)
    end

    def document
      @document ||= RSS::Parser.parse(encoded_body)
    end

    def fill_descriptions!
      document.items.each do |item|
        /([0-9A-Z]+)\.html/m =~ item.link
        article = Article.new($1)
        item.description = article.description
      end
    end
  end
end
