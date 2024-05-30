# frozen_string_literal: true

module Graphlit
  module Specifications
    module_function

    CreateSpecification = Graphlit.client.parse <<-'GRAPHQL'
      mutation($specification: SpecificationInput!) {
        createSpecification(specification: $specification) {
          id
          name
          state
          type
          serviceType
        }
      }
    GRAPHQL

    # The createSpecification mutation enables the creation of a specification
    # by accepting the specification name, serviceType and systemPrompt and it
    # returns essential details, including the ID, name, state, type and service
    # type of the newly generated specification.
    #
    # The LLM systemPrompt is a text input provided to the model to instruct it
    # on what kind of content or responses to generate. It serves as the initial
    # message or query that sets the context and guides the model's behavior,
    # helping it generate text that is relevant, informative, or creative,
    # depending on the user's needs.
    #
    # When using theOPEN_AI service type, you can assign the openAI parameters
    # for the model, model temperature, model probability and the
    # completionTokenLimit.
    #
    # Example parameter for OpenAI:
    #
    # specification: {
    #   serviceType: "OPEN_AI",
    #   systemPrompt: "You are a Machine Learning researcher, ...",
    #   openAI: {
    #     model: "GPT35_TURBO",
    #     temperature: 0.5,
    #     completionTokenLimit: 256
    #   },
    #   name: "Machine Learning Researcher"
    # }
    #
    # Example Response:
    # {
    #   "type": "COMPLETION",
    #   "serviceType": "OPEN_AI",
    #   "id": "bf20d121-8332-405f-bfe2-7789b9e19215",
    #   "name": "Machine Learning Researcher",
    #   "state": "ENABLED"
    # }

    def create_specification(specification:)
      Graphlit.client.query(CreateSpecification, variables: { specification: })
    end

    DeleteSpecification = Graphlit.client.parse <<-'GRAPHQL'
      mutation($id: ID!) {
        deleteSpecification(id: $id) {
          id
          state
        }
      }
    GRAPHQL

    # The deleteSpecification mutation enables you to delete a specification
    # by providing the id parameter. It returns the ID and state of the deleted
    # specification.
    def delete_specification(id:)
      Graphlit.client.query(DeleteSpecification, variables: { id: })
    end

    GetSpecification = Graphlit.client.parse <<-'GRAPHQL'
      query($id: ID!) {
        specification(id: $id) {
          id
          name
          creationDate
          state
          owner {
            id
          }
          type
          serviceType
          systemPrompt
          openAI {
            tokenLimit
            completionTokenLimit
            modelName
            temperature
          }
        }
      }
    GRAPHQL

    # The get specification query allows you to retrieve specific details of
    # a specification by providing the id parameter, including the ID, name,
    # creation date, state, owner ID, and type associated with the specification.
    # You can also retrieve the openai details for the LLM specification.
    #
    # Example Response:
    # {
    #   "type": "COMPLETION",
    #   "serviceType": "OPEN_AI",
    #   "systemPrompt": "You are a Machine Learning researcher, who is intelligent...",
    #   "openAI": {
    #     "modelName": "gpt-3.5-turbo",
    #     "temperature": 0.0,
    #     "completionTokenLimit": 256
    #   },
    #   "id": "bf20d121-8332-405f-bfe2-7789b9e19215",
    #   "name": "Machine Learning Researcher",
    #   "state": "ENABLED",
    #   "creationDate": "2023-07-04T01:12:31Z",
    #   "owner": {
    #     "id": "9422b73d-f8d6-4faf-b7a9-152250c862a4"
    #   }
    # }
    def get_specification(id:)
      Graphlit.client.query(GetSpecification, variables: { id: })
    end

    QuerySpecifications = Graphlit.client.parse <<-'GRAPHQL'
      query($filter: SpecificationFilter!) {
        specifications(filter: $filter) {
          results {
            id
            name
            creationDate
            state
            owner {
              id
            }
            type
            serviceType
            systemPrompt
            openAI {
              tokenLimit
              completionTokenLimit
              modelName
              temperature
            }
          }
        }
      }
    GRAPHQL

    def query_specifications(filter: {})
      Graphlit.client.query(QuerySpecifications, variables: { filter: })
    end
  end
end
