require "lib/summaries"
require "io/console"
require "stringio"

module LambdaFunction
  class Handler
    def self.process(event:, context:)
      id = event["queryStringParameters"]["id"]
      summaries = Summaries::Summary.new(id)
      summaries.fill_descriptions!
      summaries.document
    end
  end
end
