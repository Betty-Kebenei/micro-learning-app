require_relative '../../spec/spec_helper'
require_relative '../../app/controllers/application_controller'

RSpec.describe 'not_found' do
  it 'should redirect to "/" where we have a Register and Login link if user is not logged in' do
    visit '/logout'

    visit '/random'

    expect(current_path).to eq('/')
    expect(page).to have_content('Register')
    expect(page).to have_content('Login')
  end

  it 'should redirect to "/404" if user is logged in' do
    visit '/register'

    fill_in 'user[email]', with: 'test@test.com'
    fill_in 'user[password]', with: 'test@12TEST'
    fill_in 'user[con_password]', with: 'test@12TEST'

    click_on 'Submit'

    visit '/random'

    expect(current_path).to eq('/404')
    expect(page).to have_content('Page not found!')
  end
end