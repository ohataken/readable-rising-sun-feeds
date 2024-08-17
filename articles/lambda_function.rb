require_relative "lib/articles"
require "io/console"
require "stringio"

module LambdaFunction
  class Handler
    def self.process(event:, context:)
      id = event["queryStringParameters"]["id"]
      article = Articles::Article.new(id)
      article.description

      {
        isBase64Encoded: false,
        statusCode: 200,
        headers: {
          "Cache-Control": "public, max-age=31536000"
        },
        # "multiValueHeaders": { "headerName": ["headerValue", "headerValue2", ...], ... },
        body: article.to_json
      }
    end
  end
end
