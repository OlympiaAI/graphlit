# frozen_string_literal: true

module Graphlit
  module Workflows
    module_function

    CreateWorkflow = Graphlit.client.parse <<~'GRAPHQL'
      mutation($workflow: WorkflowInput!) {
        createWorkflow(workflow: $workflow) {
          id
          name
          state
          ingestion {
            collections {
              id
            }
          }
          preparation {
            summarizations {
              type
              tokens
              items
            }
          }
        }
      }
    GRAPHQL

    FULL_EXAMPLE = {
      name: "Workflow Name",
      preparation: {
        jobs: [
          {
            connector: {
              type: "DEEPGRAM",
              deepgram: {
                model: "NOVA2_MEETING",
                key: ENV["DEEPGRAM_KEY"]
              }
            }
          }
        ]
      }
    }.freeze

    def create_workflow(workflow:)
      Graphlit.client.query(CreateWorkflow, variables: { workflow: })
    end
  end
end
