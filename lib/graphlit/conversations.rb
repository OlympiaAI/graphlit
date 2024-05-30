# frozen_string_literal: true

module Graphlit
  module Conversations
    module_function

    CreateConversation = Graphlit.client.parse <<-'GRAPHQL'
      mutation($conversation: ConversationInput!) {
        createConversation(conversation: $conversation) {
          id
          name
          state
          type
          owner {
            id
          }
        }
      }
    GRAPHQL

    def create_conversation(conversation:, client: Current.account&.gc)
      client.query(CreateConversation, variables: { conversation: }).tap do |result|
        raise GraphlitError, "Error creating conversation: #{result.to_h["errors"]}" if result.to_h["errors"]&.any?
      end
    end

    DeleteAllConversations = Graphlit.client.parse <<-'GRAPHQL'
      mutation {
        deleteAllConversations {
          id
          state
        }
      }
    GRAPHQL

    def delete_all(client: Current.account&.gc)
      client.query(DeleteAllConversations).tap do |result|
        raise GraphlitError, "Error deleting all conversations: #{result.to_h["errors"]}" if result.to_h["errors"]&.any?
      end
    end

    DeleteConversation = Graphlit.client.parse <<-'GRAPHQL'
      mutation($id: ID!) {
        deleteConversation(id: $id) {
          id
          state
        }
      }
    GRAPHQL

    def delete(id:, client: Current.account&.gc)
      client.query(DeleteConversation, variables: { id: }).tap do |result|
        raise GraphlitError, "Error deleting conversation: #{result.to_h["errors"]}" if result.to_h["errors"]&.any?
      end
    end

    GetConversation = Graphlit.client.parse <<~'GRAPHQL'
      query($id: ID!) {
        conversation(id: $id) {
          id
          name
          creationDate
          state
          owner {
            id
          }
          type
          messages {
            role
            author
            message
            timestamp
            citations {
              index
              text
              content {
                id
                name
              }
            }
          }
        }
      }
    GRAPHQL

    def get(id:, client: Current.account&.gc)
      client.query(GetConversation, variables: { id: }).tap do |result|
        raise GraphlitError, "Error getting conversation: #{result.to_h["errors"]}" if result.to_h["errors"]&.any?
      end
    end

    PromptConversation = Graphlit.client.parse <<-'GRAPHQL'
      mutation($prompt: String!, $id: ID) {
        promptConversation(prompt: $prompt, id: $id) {
          conversation {
            id
          }
          message {
            role
            author
            message
            citations {
              index
              content {
                name
                creationDate
                uri
              }
              text
            }
            tokens
            completionTime
          }
          messageCount
        }
      }
    GRAPHQL

    def prompt_conversation(prompt:, id: nil, client: Current.account&.gc)
      client.query(PromptConversation, variables: { prompt:, id: }).tap do |result|
        raise GraphlitError, "Error prompting conversation: #{result.to_h["errors"]}" if result.to_h["errors"]&.any?
      end
    end

    QueryConversation = Graphlit.client.parse <<~'GRAPHQL'
      query($filter: ConversationFilter!) {
        conversations(filter: $filter) {
          results {
            id
            name
            creationDate
            state
            owner {
              id
            }
            type
          }
        }
      }
    GRAPHQL

    def query_conversations(name: "", offset: 0, limit: 100, client: Current.account&.gc)
      client.query(QueryConversation, variables: { filter: { name:, offset:, limit: } }).tap do |result|
        raise GraphlitError, "Error querying conversations: #{result.to_h["errors"]}" if result.to_h["errors"]&.any?
      end
    end
  end
end
