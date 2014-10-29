require 'test_helper'

class ProblemsControllerTest < ActionController::TestCase

  setup do
    @problem = problems(:one)
    @user = users(:one)
  end

  context "request GET :new" do
    setup { get :new, nil, {current_user_id: @user.id}}
    should respond_with(:ok)
    should render_template('new')
  end

  context "request POST :create" do
    context "with invalid problem info" do
    setup {post :create, { problem: { user_id: @user.id, description: @problem.description, tried: "" } }, {current_user_id: @user.id}  }
      should "not save a problem" do
        assert assigns[:problem].invalid?
      end
      should render_template('new')
    end

    context "with valid problem info" do
      setup do
        ActionMailer::Base.deliveries.clear
        post :create, { problem: { user_id: @user.id, description: @problem.description, tried: @problem.tried } }, {current_user_id: @user.id}
      end
      should "save the problem" do
        assert assigns[:problem]
        assert assigns[:problem].persisted?
      end
      should "redirect to problem's show view" do
        assert_redirected_to problem_path(assigns(:problem))
      end
      should "send problem_posted email" do
        email = ActionMailer::Base.deliveries.last
        assert_equal "You've got a problem", email.subject
      end
    end
  end

  context "request GET :index" do
    setup { get :index, nil, {current_user_id: @user.id}}
    should respond_with(:ok)
    should render_template('index')
  end

  context "request GET :show" do
    setup { get :show, { id: problems(:one) }, {current_user_id: @user.id} }
    should respond_with(:ok)
    should render_template('show')
    # should render_template(partial: 'notes/_new')
  end

  context "request PATCH :resolve" do
    context "with html format" do
      setup { patch :resolve, { id: @problem, format: "html" }, {current_user_id: @user.id} }
      should "resolve the problem" do
        assert assigns[:problem].resolved
      end
      should "redirect to problems page" do
        assert_redirected_to root_path
      end
    end
    context "with js format" do
      setup { patch :resolve, { id: @problem, format: "js" }, {current_user_id: @user.id} }
      should "resolve the problem" do
        assert assigns[:problem].resolved
      end
      should respond_with(:ok)
      should_eventually "fade out and remove the problem entry" do
        # ??? Capy tests
      end
    end
  end
 end
