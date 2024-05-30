# frozen_string_literal: true

require "graphql/client"
require "graphql/client/http"
require "jwt"

require_relative "graphlit/version"

module Graphlit
  module_function

  class GraphlitClient
    attr_reader :gql_client

    delegate_missing_to :gql_client

    def initialize(gql_client)
      @gql_client = gql_client
    end

    def parse(str, filename = nil, lineno = nil)
      @gql_client.parse(str, filename, lineno)
    end

    def query(definition, variables: {}, context: {})
      puts "🔍 Querying #{definition} #{variables} #{context}"
      @gql_client.query(definition, variables:, context:).tap do |result|
        puts "🔍 Graphlit Result: #{result.to_h}"
      end
    end
  end

  class GraphlitError < StandardError
    attr_reader :message

    def initialize(message)
      super
      @message = message
      puts "💡💥 GraphlitError: #{message}"
    end
  end

  DefaultHTTP = GraphQL::Client::HTTP.new(ENV.fetch("GRAPHLIT_ENDPOINT", "https://data-scus.graphlit.io/api/v1/graphql")) do
    def headers(_context)
      payload = {
        "https://graphlit.io/jwt/claims": {
          "x-graphlit-environment-id": ENV.fetch("GRAPHLIT_ENVIRONMENT_ID"),
          "x-graphlit-organization-id": ENV.fetch("GRAPHLIT_ORGANIZATION_ID"),
          "x-graphlit-role": "Owner"
        },
        exp: Time.now.to_i + 3600 * 24 * 365, # expires 1 year from now
        iss: "graphlit",
        aud: "https://portal.graphlit.io"
      }.freeze

      @@token ||= JWT.encode(payload, ENV.fetch("GRAPHLIT_SECRET"), "HS256") # rubocop:disable Style/ClassVars

      { "Authorization": "Bearer #{@@token}" }
    end
  end

  unless File.exist?("config/graphlit-schema.json")
    # Fetch latest schema, this will make a network request
    GraphQL::Client.load_schema(DefaultHTTP)
    # However, it's smart to dump this to a JSON file and load from disk
    GraphQL::Client.dump_schema(DefaultHTTP, "config/graphlit-schema.json")
  end

  SCHEMA = GraphQL::Client.load_schema("config/graphlit-schema.json")

  def client
    @client ||= GraphQL::Client.new(schema: SCHEMA, execute: DefaultHTTP).then do |gql_client|
      GraphlitClient.new(gql_client)
    end
  end
end

require_relative "graphlit/collections"
require_relative "graphlit/content"
require_relative "graphlit/conversations"
require_relative "graphlit/labels"
require_relative "graphlit/projects"
require_relative "graphlit/queries"
require_relative "graphlit/specifications"
require_relative "graphlit/workflows"
