require "test_helper"

class AlternatesTest < ActionDispatch::IntegrationTest
  extend BaseActions

  test_base_actions base_url: "/alternates", model: :document, with_id: 100,
                    for_params: {document: {name: "New document"}}
end
