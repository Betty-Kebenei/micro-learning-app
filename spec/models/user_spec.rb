require_relative '../../spec/spec_helper'
require_relative '../../app/models/user'

RSpec.describe 'new user added to database' do
  context 'when valid info is given' do
    let(:user) {
      User.new('email'=> 'test@test.com', 'password'=> 'test@12TEST')
    }

    it 'adds a user if the user doesn\'t already exists' do
      new_user = user.save

      expect(new_user).to eq(true)
    end
  end

  context 'when invalid info is given' do
    let(:user) {
      User.new('email'=> 'test@test.com', 'password'=> 'test@TEST')
    }

    it 'does not save the user is the password is invalid' do
      invalid_user = user.save

      expect(invalid_user).to eq(false)
    end
  end
end