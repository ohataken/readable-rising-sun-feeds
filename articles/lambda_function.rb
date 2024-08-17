require_relative "lib/articles"
require "io/console"
require "stringio"

module LambdaFunction
  class Handler
    def self.process(event:,context:)
      id = event["queryStringParameters"]["id"]
      article = Articles::Article.new(id)
      article.description
    end
  end
end
