require_relative '../../spec/spec_helper'
require_relative '../../app/models/user'

RSpec.describe 'User Model' do
  context 'new user added to database' do
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

  context 'login user' do
    context 'when valid info is given' do
      it 'the user is found' do
        User.create('email'=> 'test@test.com', 'password'=> 'test@12TEST')
        user = User.find_by(email: 'test@test.com')

        expect(user.email).to eq('test@test.com')
      end
    end

    context 'when invalid info is given' do
      it 'the user is not found' do
        User.create('email'=> 'test@test.com', 'password'=> 'test@12TEST')
        user = User.find_by(email: 'test@t.com')

        expect(user).to eq(nil)
      end
    end
  end
end