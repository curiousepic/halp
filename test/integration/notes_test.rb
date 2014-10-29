class NotesTest < ActionDispatch::IntegrationTest
  context "while logged in" do
    setup do
      visit new_login_path
      fill_in "Email", with: users(:one).email
      fill_in "Password", with: default_password
      click_button "Log in"
    end

    context "with a given problem" do
      setup do
        @problem = problems(:one)
      end

      should "be able to add a note" do
        visit problem_path(@problem)
        fill_in "note_text", with: "whooo"
        click_on "Submit"

        assert page.has_content?("whooo")
      end
    end


  end
end