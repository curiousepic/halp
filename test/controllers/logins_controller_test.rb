  require 'test_helper'

  class LoginsControllerTest < ActionController::TestCase

    context "GET :new" do
      setup { get :new }

      should respond_with(:ok)
      should render_template(:new)

      end


    context "request POST :create" do
      setup do
        @user = User.new(name: Faker::Name.name,
                         email: Faker::Internet.email,
                         password: "password",
                         password_confirmation: "password")
        @user.save
      end

    context "with invalid login info" do
      setup { post :create, {email: @user.email, password: ""}}
      should "re-render the form" do
        assert_template :new
      end
    end

    context "with valid login info" do
      setup {post :create, {email: @user.email, password: @user.password}}
      should "create a session" do
        assert session[:current_user_id], "Should have a session"
      end
      should "redirect to homepage" do
        assert_redirected_to root_path
      end
    end
  end
      context "request DELETE :destroy" do
        setup do
          @user = User.new(name: Faker::Name.name,
                           email: Faker::Internet.email,
                           password: "password",
                           password_confirmation: "password")
          @user.save
          post :create, {email: @user.email, password: @user.password}
        end
          context "on an active session" do
            setup { delete :destroy }
            should "delete the session" do
              refute session[:current_user_id]
            end

          should "and render login page" do
            assert_template :new
          end
        end
    end
  end

