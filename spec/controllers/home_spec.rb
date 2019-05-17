require_relative '../../spec/spec_helper'
require_relative '../../app/controllers/application_controller'

RSpec.describe 'home' do
  it 'should display signup link if user has not logged in' do
    visit '/logout'

    expect(current_path).to eq('/')
    expect(page).to have_content('Register')
  end
  it 'should display logout link if user has logged in' do
    visit '/register'

    fill_in 'user[email]', with: 'test@test.com'
    fill_in 'user[password]', with: 'test@12TEST'
    fill_in 'user[con_password]', with: 'test@12TEST'

    click_on 'Submit'

    expect(current_path).to eq('/')
    expect(page).to have_content('Logout')
    expect(page).to have_content('Topic')
  end
end