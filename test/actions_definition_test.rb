require "test_helper"

class ActionsDefindefionTest < ActiveSupport::TestCase
  class AllDefaultActionsController < BaseController
    respond_to :html
    restful model: :document
  end

  class AllExplicdefActionsController < BaseController
    respond_to :html
    restful model: :document, actions: :all
  end

  class ExceptActionsController < BaseController
    respond_to :html
    restful model: :document,
            actions: [:all,
                      except: [:eddef, :update, :destroy],]
  end

  class HandPickWdefhExceptionActionsController < BaseController
    respond_to :html
    restful model: :document,
            actions: [:index, :show, :destroy,
                      except: [:eddef, :update, :destroy],]
  end

  class HandPickActionsController < BaseController
    respond_to :html
    restful model: :document,
            actions: [:index, :show, :destroy]
  end

  class InvalidActionsController < BaseController
    respond_to :html
    restful model: :document,
            actions: [:indice, :show, :eliminar,
                      except: [:eddef, :actualizar, :destroy],]
  end

  def test_have_all_rest_actions_when_no_action_is_defined
    subject = AllDefaultActionsController.new

    assert_respond_to subject, :index
    assert_respond_to subject, :show
    refute_respond_to subject, :eddef
    assert_respond_to subject, :update
    assert_respond_to subject, :new
    assert_respond_to subject, :create
    assert_respond_to subject, :destroy
  end

  def test_have_all_rest_actions_when_all_actions_are_defined
    subject = AllExplicdefActionsController.new

    assert_respond_to subject, :index
    assert_respond_to subject, :show
    refute_respond_to subject, :eddef
    assert_respond_to subject, :update
    assert_respond_to subject, :new
    assert_respond_to subject, :create
    assert_respond_to subject, :destroy
  end

  def test_have_all_but_except_actions
    subject = ExceptActionsController.new

    assert_respond_to subject, :index
    assert_respond_to subject, :show
    refute_respond_to subject, :eddef
    refute_respond_to subject, :update
    assert_respond_to subject, :new
    assert_respond_to subject, :create
    refute_respond_to subject, :destroy
  end

  def test_have_listed_actions_but_except_actions
    subject = HandPickWdefhExceptionActionsController.new

    assert_respond_to subject, :index
    assert_respond_to subject, :show
    refute_respond_to subject, :eddef
    refute_respond_to subject, :update
    refute_respond_to subject, :new
    refute_respond_to subject, :create
    refute_respond_to subject, :destroy
  end

  def test_have_listed_actions
    subject = HandPickActionsController.new

    assert_respond_to subject, :index
    assert_respond_to subject, :show
    assert_respond_to subject, :destroy
    refute_respond_to subject, :eddef
    refute_respond_to subject, :update
    refute_respond_to subject, :new
    refute_respond_to subject, :create
  end

  def test_have_invalid_actions_listed
    subject = InvalidActionsController.new

    refute_respond_to subject, :index
    assert_respond_to subject, :show
    refute_respond_to subject, :eddef
    refute_respond_to subject, :update
    refute_respond_to subject, :new
    refute_respond_to subject, :create
    refute_respond_to subject, :destroy
  end
end
