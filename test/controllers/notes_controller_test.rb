require 'test_helper'

class NotesControllerTest < ActionController::TestCase

  setup do
    @user = users(:one)
    @user_two = users(:two)
    @problem_one = problems(:one)
    @problem_two = problems(:two)
    @note = notes(:one)
  end

  context "request POST :create" do

    context "with invalid info" do
      setup do
        ActionMailer::Base.deliveries.clear
        post :create, { note: { user_id: @user.id, problem_id: @problem_two.id, text: "" } }, {current_user_id: @user.id}
      end
      should "not send an email" do
        assert_empty ActionMailer::Base.deliveries
      end
      should "redirect to problem's show view" do
      assert_redirected_to problem_path(@problem_two)
      end
      should "instantiate an invalid note" do
        assert assigns[:note].invalid?
      end
    end

    context "with valid info" do

      context "with html format" do
        setup { post :create, { note: { user_id: @user.id, problem_id: @problem_two.id, text: "asdf", format: "html"  } }, {current_user_id: @user.id} }
        should "save a note" do
          assert assigns[:note]
          assert assigns[:note].persisted?
        end
        should "redirect to problem's show view" do
          assert_redirected_to problem_path(@problem_two)
        end
      end

      context "with js format" do
        setup { post :create, { note: { user_id: @user.id, problem_id: @problem_two.id, text: "asdf", format: "js"  } }, {current_user_id: @user.id} }
        should "save a note" do
          assert assigns[:note]
          assert assigns[:note].persisted?
        end
        should respond_with(:ok)
        should_eventually "magically make the note appear" do
          # ??? Capy tests
        end
      end

      context "when the author adds a note" do
        setup do
          ActionMailer::Base.deliveries.clear
          post :create, { note: { user_id: @user.id, problem_id: @problem_one.id, text: "note to self" } },
                        {current_user_id: @user.id}
        end
        should "not send an email" do
          assert_empty ActionMailer::Base.deliveries
        end
      end

      context "when a non-author adds a note" do
        setup do
          ActionMailer::Base.deliveries.clear
          post :create, { note: { user_id: @user.id, problem_id: @problem_two.id, text: "asdf" } }, {current_user_id: @user.id}
        end
        should "send note_added email" do
          email = ActionMailer::Base.deliveries.last
          assert_equal "Note added on your problem", email.subject
          assert_equal @problem_two.user.email, email.to[0]
        end
      end
    end
  end

end
