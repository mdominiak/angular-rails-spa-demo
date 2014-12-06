require 'rails_helper'

describe 'Meals', type: :feature, js: true do

  it 'CRUD' do
    visit '/'
    within '.jumbotron' do
      click_on 'Sign up'
    end
    fill_in 'Email', with: 'matt@gmail.com'
    fill_in 'inputPassword', with: 'password'
    fill_in 'Confirm password', with: 'password'
    click_button 'Sign up'

    expect(page).to have_content('Add Meal')
    user = User.last
    click_on user.email
    click_on 'Logout'

    within '.jumbotron' do
      click_on 'Login'
    end
    fill_in 'Email', with: 'matt@gmail.com'
    fill_in 'Password', with: 'password'
    click_button 'Login'

    click_on 'Add Meal'
    fill_in 'Calories', with: 1000
    fill_in 'Description', with: 'eggs'
    click_button 'Save Meal'
    expect(page).to have_content('Add Meal')
    expect(page).to have_content('eggs')

    click_link 'Edit'
    fill_in 'Calories', with: 1234
    click_on 'Save Meal'
    expect(page).to have_content('Add Meal')
    expect(page).to have_content('1234')

    click_on 'Delete'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content('No meals to show.')
  end
end