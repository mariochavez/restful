require 'test_helper'

describe DocumentsController do
  extend BaseActions

  test_base_actions base_url: "/documents", model: :document, with_id: 100,
    for_params: { document: { name: 'New document' } }
end
