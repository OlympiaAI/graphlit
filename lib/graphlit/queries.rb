# frozen_string_literal: true

module Graphlit
  module Queries
    module_function

    QueryCategories = Graphlit.client.parse <<-'GRAPHQL'
      query QueryCategories($filter: CategoryFilter!) {
        categories(filter: $filter) {
          results {
            id
            name
          }
        }
      }
    GRAPHQL

    def query_categories(name:, offset: 0, limit: 100, client: Current.account&.gc)
      client.query(QueryCategories, variables: { filter: { name:, offset:, limit: } })
    end

    QueryLabels = Graphlit.client.parse <<-'GRAPHQL'
      query($filter: LabelFilter!) {
        labels(filter: $filter) {
          results {
            id
            name
          }
        }
      }
    GRAPHQL

    def query_labels(offset: 0, limit: 100, client: Current.account&.gc)
      client.query(QueryLabels, variables: { filter: { offset:, limit: } })
    end
  end
end
