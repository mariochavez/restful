require 'test_helper'

describe 'Actions definition' do
  it 'have all REST actions when no action is defined' do
    ##
    # Controller class for tests
    class AllDefaultActionsController < BaseController
      respond_to :html
      restful model: :document
    end

    subject = AllDefaultActionsController.new

    subject.must_respond_to :index
    subject.must_respond_to :show
    subject.must_respond_to :edit
    subject.must_respond_to :update
    subject.must_respond_to :new
    subject.must_respond_to :create
    subject.must_respond_to :destroy
  end

  it 'have all REST actions when all actions are defined' do
    ##
    # Controller class for tests
    class AllExplicitActionsController < BaseController
      respond_to :html
      restful model: :document, actions: :all
    end

    subject = AllExplicitActionsController.new

    subject.must_respond_to :index
    subject.must_respond_to :show
    subject.must_respond_to :edit
    subject.must_respond_to :update
    subject.must_respond_to :new
    subject.must_respond_to :create
    subject.must_respond_to :destroy
  end

  it 'have all but except actions' do
    ##
    # Controller class for tests
    class ExceptActionsController < BaseController
      respond_to :html
      restful model: :document,
        actions: [:all,
                   except: [:edit, :update, :destroy]]
    end

    subject = ExceptActionsController.new

    subject.must_respond_to :index
    subject.must_respond_to :show
    subject.wont_respond_to :edit
    subject.wont_respond_to :update
    subject.must_respond_to :new
    subject.must_respond_to :create
    subject.wont_respond_to :destroy
  end

  it 'have listed actions but except actions' do
    ##
    # Controller class for tests
    class HandPickWithExceptionActionsController < BaseController
      respond_to :html
      restful model: :document,
        actions: [:index, :show, :destroy,
                  except: [:edit, :update, :destroy]]
    end

    subject = HandPickWithExceptionActionsController.new

    subject.must_respond_to :index
    subject.must_respond_to :show
    subject.wont_respond_to :edit
    subject.wont_respond_to :update
    subject.wont_respond_to :new
    subject.wont_respond_to :create
    subject.wont_respond_to :destroy
  end

  it 'have listed actions' do
    ##
    # Controller class for tests
    class HandPickActionsController < BaseController
      respond_to :html
      restful model: :document,
        actions: [:index, :show, :destroy]
    end

    subject = HandPickActionsController.new

    subject.must_respond_to :index
    subject.must_respond_to :show
    subject.must_respond_to :destroy
    subject.wont_respond_to :edit
    subject.wont_respond_to :update
    subject.wont_respond_to :new
    subject.wont_respond_to :create
  end

  it 'have invalid actions listed' do
    ##
    # Controller class for tests
    class InvalidActionsController < BaseController
      respond_to :html
      restful model: :document,
        actions: [:indice, :show, :eliminar,
                  except: [:edit, :actualizar, :destroy]]
    end

    subject = InvalidActionsController.new

    subject.wont_respond_to :index
    subject.must_respond_to :show
    subject.wont_respond_to :edit
    subject.wont_respond_to :update
    subject.wont_respond_to :new
    subject.wont_respond_to :create
    subject.wont_respond_to :destroy
  end
end
