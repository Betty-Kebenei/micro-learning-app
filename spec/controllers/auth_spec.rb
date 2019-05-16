require_relative '../../spec/spec_helper'
require_relative '../../app/controllers/application_controller'

RSpec.describe 'authentication' do
  context 'signup' do
    it 'should display a signup form' do
      visit '/register'

      expect(page).to have_content('Register to get started!')
    end

    context 'when details are valid' do
      it 'should post a new user and redirect to "/"' do
        visit '/register'

        fill_in 'user[email]', with: 'test@test.com'
        fill_in 'user[password]', with: 'test@12TEST'
        fill_in 'user[con_password]', with: 'test@12TEST'

        click_on 'Submit'

        expect(current_path).to eq('/')
      end
    end

    context 'when details are invalid' do
      it 'should not post a new user but redirect back to "/register"' do
        visit '/register'

        fill_in 'user[email]', with: 'test@test.com'
        fill_in 'user[password]', with: 'test@12TEST'
        fill_in 'user[con_password]', with: 'test@12'

        click_on 'Submit'

        expect(current_path).to eq('/register')
      end
    end
  end

  context 'login' do
    it 'should display a login form' do
      visit '/login'

      expect(page).to have_content('Login to get started!')
    end

    context 'when details are valid' do
      it 'should login the user and redirect to "/"' do
        visit '/register'

        fill_in 'user[email]', with: 'test@test.com'
        fill_in 'user[password]', with: 'test@12TEST'
        fill_in 'user[con_password]', with: 'test@12TEST'

        click_on 'Submit'

        visit '/login'

        fill_in 'user[email]', with: 'test@test.com'
        fill_in 'user[password]', with: 'test@12TEST'

        click_on 'Submit'

        expect(current_path).to eq('/')
      end
    end

    context 'when details are invalid' do
      it 'should not login the user but redirect back to "/login"' do
        visit '/register'

        fill_in 'user[email]', with: 'test@test.com'
        fill_in 'user[password]', with: 'test@12TEST'
        fill_in 'user[con_password]', with: 'test@12TEST'

        click_on 'Submit'

        visit '/login'

        fill_in 'user[email]', with: 'test@test.com'
        fill_in 'user[password]', with: 'test@12'

        click_on 'Submit'

        expect(current_path).to eq('/login')
      end
    end
  end
end