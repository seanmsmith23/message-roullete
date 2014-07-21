require "rspec"
require "capybara"

feature "Messages" do
  scenario "As a user, I can submit a message" do
    visit "/"

    expect(page).to have_content("Message Roullete")

    fill_in "Message", :with => "Hello Everyone!"

    click_button "Submit"

    expect(page).to have_content("Hello Everyone!")
  end

  scenario "As a user, I see an error message if I enter a message > 140 characters" do
    visit "/"

    fill_in "Message", :with => "a" * 141

    click_button "Submit"

    expect(page).to have_content("Message must be less than 140 characters.")
  end

end

feature "Editing Messages" do
  scenario "As a user I can edit a message and see autofilled message on edit page" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    click_button "Edit"

    expect(page).to have_content("Edit Message")
    expect(find_field('edit_message').value).to have_content("Hello Everyone!")

    fill_in "edit_message", with: "Hello Nobody!"
    click_button "Submit"

    expect(page).to have_content("Hello Nobody!")
  end

  scenario "User should see error message if edit is more than 140 chars" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    click_button "Edit"

    fill_in "edit_message", :with => "a" * 141
    click_button "Submit"

    expect(page).to have_content("Message must be less than 140 characters.")
    expect(page).to have_content("Edit Message")
  end
end

feature "Deleting Messages" do
  scenario "User can click delete button and delete message" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"

    expect(page).to have_content("Hello Everyone!")

    click_button("Delete")

    expect(page).to_not have_content("Hello Everyone!")
  end
end
