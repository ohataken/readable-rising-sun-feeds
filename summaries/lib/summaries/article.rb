# frozen_string_literal: true

require "json"
require "uri"
require "net/http"
require "rss"

module Summaries
  class Article
    attr_accessor :id

    def initialize id
      @id = id
    end

    def hostname
      ENV.fetch("ARTICLES_HOSTNAME", "example.com")
    end

    def uri_string
      "https://#{hostname}/articles?id=#{@id}"
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

    def to_hash
      @hash ||= JSON.parse(encoded_body)
    end

    def description
      encoded_body
    end
  end
end
