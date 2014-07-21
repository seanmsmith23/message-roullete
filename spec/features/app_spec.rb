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

  scenario "As a user I can edit a message and see autofilled message on edit page" do
    visit "/"

    expect(page).to have_content("Message Roullete")

    fill_in "Message", :with => "Hello Everyone!"

    click_button "Submit"

    expect(page).to have_content("Hello Everyone!")

    click_button "Edit"

    expect(page).to have_content("Edit Message")
    expect(find_field('edit_message').value).to have_content("Hello Everyone!")

    fill_in "edit_message", with: "Hello Nobody!"
    click_button "Submit"

    expect(page).to have_content("Hello Nobody!")
  end
end
