# frozen_string_literal: true

module Graphlit
  module Labels
    module_function

    QueryLabels = Graphlit.client.parse <<~QUERY
      query($filter: LabelFilter) {
        labels(filter: $filter) {
          results {
            id
            name
            description
          }
        }
      }
    QUERY

    def query_labels(filter: {}, client: Current.account&.gc)
      client.query(QueryLabels, variables: { filter: }).tap do |result|
        raise GraphlitError, "Error querying labels: #{result.to_h["errors"]}" if result.to_h["errors"]&.any?
      end
    end
  end
end
