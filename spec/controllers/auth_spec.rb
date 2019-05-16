require_relative '../../spec/spec_helper'
require_relative '../../app/controllers/application_controller'

RSpec.describe 'signup' do
  it 'should display a signup form' do
    visit '/register'

    expect(page).to have_content('Register to get started!')
  end

  context 'when details are valid' do
    it 'should post a new and redirect to "/"' do
      visit '/register'

      fill_in 'user[email]', with: 'test@test.com'
      fill_in 'user[password]', with: 'test@12TEST'
      fill_in 'user[con_password]', with: 'test@12TEST'

      click_on 'Submit'

      expect(current_path).to eq('/')
    end
  end

  context 'when details are invalid' do
    it 'should not post a new but redirect back to "/register"' do
      visit '/register'

      fill_in 'user[email]', with: 'test@test.com'
      fill_in 'user[password]', with: 'test@12TEST'
      fill_in 'user[con_password]', with: 'test@12'

      click_on 'Submit'

      expect(current_path).to eq('/register')
    end
  end
end