# frozen_string_literal: true

module Graphlit
  module Content
    module_function

    DeleteContent = Graphlit.client.parse <<~'GRAPHQL'
      mutation($id: ID!) {
        deleteContent(id: $id) {
          id
          state
        }
      }
    GRAPHQL

    def delete_content(id:, client: Current.account&.gc)
      client.query(DeleteContent, variables: { id: }).tap do |result|
        raise GraphlitError, "Error deleting content: #{result.to_h["errors"]}" if result.to_h["errors"]&.any?
      end
    end

    IngestFile = Graphlit.client.parse <<-'GRAPHQL'
      mutation($uri: URL!, $collections: [EntityReferenceInput!]) {
        ingestFile(uri: $uri, collections: $collections) {
          id
          name
          state
          type
          fileType
          uri
        }
      }
    GRAPHQL

    def ingest_file(uri:, workflow_id: nil, collection_ids: [], client: Current.account&.gc)
      variables = { uri: }
      variables[:workflow] = { id: workflow_id } if workflow_id.present?
      variables[:collections] = collection_ids.map { |id| { id: } } if collection_ids.any?
      client.query(IngestFile, variables: { uri: }).tap do |result|
        raise GraphlitError, "Error ingesting file: #{result.to_h["errors"]}" if result.to_h["errors"]&.any?
      end
    end

    IngestPage = Graphlit.client.parse <<-'GRAPHQL'
    mutation($uri: URL!, $collections: [EntityReferenceInput!]) {
      ingestPage(uri: $uri, collections: $collections) {
          id
          name
          state
          type
          fileType
          uri
        }
      }
    GRAPHQL

    def ingest_page(uri:, workflow_id: nil, collection_ids: [], client: Current.account&.gc)
      variables = { uri: }
      variables[:workflow] = { id: workflow_id } if workflow_id.present?
      variables[:collections] = collection_ids.map { |id| { id: } } if collection_ids.any?
      client.query(IngestPage, variables:).tap do |result|
        raise GraphlitError, "Error ingesting page: #{result.to_h["errors"]}" if result.to_h["errors"]&.any?
      end
    end

    TEXT = "TEXT"
    MARKDOWN = "MARKDOWN"

    IngestText = Graphlit.client.parse <<-'GRAPHQL'
      mutation($name: String!, $text: String!, $textType: TextTypes, $uri: URL, $collections: [EntityReferenceInput!], $workflow: EntityReferenceInput) {
        ingestText(name: $name, text: $text, textType: $textType, uri: $uri, workflow: $workflow, collections: $collections) {
          id
          name
          state
          type
          fileType
          mimeType
          uri
          text
          collections {
            id
            name
          }
        }
      }
    GRAPHQL

    def ingest_text(name:, text:, text_type: nil, collection_ids: [], uri: nil, workflow_id: nil, client: Current.account&.gc)
      raise GraphlitError, "text_type must be one of #{TEXT}, #{MARKDOWN}" unless [TEXT, MARKDOWN].include?(text_type)

      variables = { name:, text:, text_type:, uri: }
      variables[:collections] = collection_ids.map { |id| { id: } } if collection_ids.any?
      variables[:workflow] = { id: workflow_id } if workflow_id.present?
      client.query(IngestText, variables:).tap do |result|
        raise GraphlitError, "Error ingesting text: #{result.to_h["errors"]}" if result.to_h["errors"]&.any?
      end
    end

    GetContent = Graphlit.client.parse <<-'GRAPHQL'
      query($id: ID!) {
        content(id: $id) {
          id
          name
          creationDate
          state
          text
          mezzanineUri
          transcriptUri
          collections {
            id
            name
          }
        }
      }
    GRAPHQL

    def get_content(id:, client: Current.account&.gc)
      client.query(GetContent, variables: { id: }).data.content
    end

    QueryContents = Graphlit.client.parse <<-'GRAPHQL'
      query($filter: ContentFilter!) {
        contents(filter: $filter) {
          results {
            id
            name
            creationDate
            state
            owner {
              id
            }
            collections {
              id
              name
            }
            originalDate
            finishedDate
            workflowDuration
            uri
            text
            type
            fileType
            mimeType
            fileName
            fileSize
            masterUri
            mezzanineUri
            transcriptUri
          }
        }
      }
    GRAPHQL

    def query_contents(filter:, client: Current.account&.gc)
      client.query(QueryContents, variables: { filter: })
    end

    VectorSearch = Graphlit.client.parse <<-'GRAPHQL'
      query($filter: ContentFilter!) {
        contents(filter: $filter) {
          results {
            id
            name
            creationDate
            type
            fileName
            fileSize
            collections {
              id
            }
            pages {
              index
              chunks {
                text
                relevance
              }
            }
            segments {
              startTime
              endTime
              text
              relevance
            }
          }
        }
      }
    GRAPHQL

    def vector_search(search:, collection_ids:, limit: 10, client: Current.account&.gc)
      client.query(VectorSearch, variables: {
                     filter: {
                       collections: collection_ids.map { |id| { id: } },
                       search:,
                       searchType: "VECTOR",
                       offset: 0,
                       limit:
                     }
                   })
    end
  end
end
