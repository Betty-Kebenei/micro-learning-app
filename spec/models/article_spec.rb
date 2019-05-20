require_relative '../../spec/spec_helper'
require_relative '../../app/models/article'

RSpec.describe 'Article Model' do
  context 'when valid info is given' do
    User.create('email'=> 'test@test.com', 'password'=> 'test@12TEST')
    user = User.find_by(email: 'test@test.com')
    let(:article) {
      Article.new('url'=> 'http://testtest.com', 'user_id'=> user.id)
    }

    it 'adds an article\'s details' do
      new_article = article.save

      expect(new_article).to eq(true)
    end
  end
end
