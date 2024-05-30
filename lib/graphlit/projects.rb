# frozen_string_literal: true

module Graphlit
  module Projects
    module_function

    QueryProject = Graphlit.client.parse <<~QUERY
      query {
        project {
          id
          name
          environmentType
          platform
          region
          creationDate
        }
      }
    QUERY

    def query_project
      # use the default client since not scoped to account
      Graphlit.client.query(QueryProject)
    end

    # The updateProject mutation allows you to specify the default
    # content workflow and/or the default specification to be
    # utilized by the project. The default workflow is used by
    # feeds and content mutations, when no other workflow has been
    # assigned. The default specification is used by conversations,
    # when no other specification has been assigned.
    #
    # Parameters:
    #   project: {
    #     workflow: {
    #       id: "3b1eefd1-4f3f-4f1c-8a58-ed2ae972da4d"
    #     },
    #     specification: {
    #       id: "1bf26859-c9c8-4361-8c60-0fac0dee6985"
    #     }
    #   }
    # }

    UpdateProject = Graphlit.client.parse <<~QUERY
      mutation($project: ProjectUpdateInput!) {
        updateProject(project: $project) {
          id
          name
        }
      }
    QUERY

    def update_project(project:)
      # use the default client since not scoped to account
      Graphlit.client.query(UpdateProject, variables: { project: })
    end
  end
end
