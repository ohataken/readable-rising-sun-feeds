require "lib/summaries"
require "io/console"
require "stringio"

module LambdaFunction
  class Handler
    def self.process(event:, context:)
      id = event["queryStringParameters"]["id"]
      summaries = Summaries::Summary.new(id)
      summaries.fill_descriptions!

      {
        isBase64Encoded: false,
        statusCode: 200,
        headers: {
          "Cache-Control": "public, max-age=3600"
        },
        # "multiValueHeaders": { "headerName": ["headerValue", "headerValue2", ...], ... },
        body: summaries.document.to_s
      }
    end
  end
end
