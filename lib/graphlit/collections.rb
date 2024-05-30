# frozen_string_literal: true

module Graphlit
  module Collections
    module_function

    AddCollectionContents = Graphlit.client.parse <<~QUERY
      mutation($id: ID!, $contents: [EntityReferenceInput!]!) {
        addCollectionContents(id: $id, contents: $contents) {
          id
          name
          state
          type
          contents {
            id
            name
          }
        }
      }
    QUERY

    def add_collection_contents(id:, content_ids:, client: Current.account&.gc)
      contents = content_ids.map { |content_id| { id: content_id } }
      client.query(AddCollectionContents, variables: { id:, contents: })
    end

    AddContentsToCollections = Graphlit.client.parse <<~QUERY
      mutation($contents: [EntityReferenceInput!]!, $collections: [EntityReferenceInput!]!) {
        addContentsToCollections(contents: $contents, collections: $collections) {
          contents {
            id
            collections {
              id
            }
          }
        }
      }
    QUERY

    def add_contents_to_collections(content_ids:, collection_ids:, client: Current.account&.gc)
      contents = content_ids.map { |content_id| { id: content_id } }
      collections = collection_ids.map { |collection_id| { id: collection_id } }
      client.query(AddContentsToCollections, variables: { contents:, collections: })
    end

    CreateCollection = Graphlit.client.parse <<~QUERY
      mutation($collection: CollectionInput!) {
        createCollection(collection: $collection) {
          id
          name
          state
          type
          contentCount
        }
      }
    QUERY

    def create_collection(name:, client: Current.account&.gc)
      # use the default client since not scoped to account
      client.query(CreateCollection, variables: { collection: { name: } })
    end

    GetCollection = Graphlit.client.parse <<~QUERY
      query($id: ID!) {
        collection(id: $id) {
          id
          name
          owner {
            id
          }
        }
      }
    QUERY

    def get_collection(id:, client: Current.account&.gc)
      client.query(GetCollection, variables: { id: })
    end

    QueryCollection = Graphlit.client.parse <<~QUERY
      query($filter: CollectionFilter!) {
        collections(filter: $filter) {
          results {
            id
            name
            contents {
              id
              name
            }
          }
        }
      }
    QUERY

    def query_collection(id:, client: Current.account&.gc)
      client.query(QueryCollection, variables: { filter: { id: } })
    end
  end
end
