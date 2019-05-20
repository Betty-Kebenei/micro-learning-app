require_relative '../../spec/spec_helper'
require_relative '../../app/controllers/application_controller'

RSpec.describe 'search' do
  it 'should search for articles when a user submits the topic' do
    visit '/logout'
    visit '/register'

    fill_in 'user[email]', with: 'test@test.com'
    fill_in 'user[password]', with: 'test@12TEST'
    fill_in 'user[con_password]', with: 'test@12TEST'

    click_on 'Submit'

    expect(current_path).to eq('/')

    fill_in 'article[topic]', with: 'introduction to ruby'

    click_on 'Submit'

    expect(current_path).to eq('/article')
  end
end