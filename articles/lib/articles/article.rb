# frozen_string_literal: true

require "json"
require "uri"
require "net/http"
require "nokogiri"

module Articles
  class Article
    attr_accessor :id

    def initialize id
      @id = id
    end

    def hostname
      ENV.fetch("ARTICLES_HOSTNAME", "example.com")
    end

    def uri_string
      "https://#{hostname}/articles/#{@id}.html?ref=rss"
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
      @document ||= Nokogiri::HTML(encoded_body)
    end

    def description_paragraphs
      document.css("main#main > div.nfyQp > p")
    end

    def description
      description_paragraphs.map(&:inner_text).join(" ")
    end

    def image
      document.at("main#main > div.nfyQp > div.w8Bsl > a > figure > img")
    end

    def image_src
      image&.attributes&.[]("srcset")&.value
    end

    def to_json
      {description: description, image_src: image_src}.to_json
    end
  end
end
