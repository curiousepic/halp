class NotesTest < ActionDispatch::IntegrationTest
  context "while logged in" do
    setup do
      visit new_login_path
      fill_in "Email", with: users(:one).email
      fill_in "Password", with: default_password
      click_button "Log in"
    end

    context "with a given problem you created" do
      setup do
        @problem = problems(:one)
      end

      should "be able to resolve it in index" do
        visit root_path
        assert page.has_content?(@problem.description[0...30])

        within("#problem_#{@problem.id}") do
          click_link "Resolve"
        end
        assert page.has_no_content?(@problem.description[0...30])

      end


    end


  end
end