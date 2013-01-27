require 'spec_helper'
require 'rack/test'

describe Api::V1 do
  let(:application) { FactoryGirl.create :oauth_application }
  let(:api_host) { 'http://api.ares-ensiie.eu' }

  describe 'user resource' do
    describe 'get a single user' do
      let(:user) { FactoryGirl.create(:user) }
      let!(:request) { get "#{api_host}/users/#{user.to_param}?client_id=#{application.uid}&client_secret=#{application.secret}" }

      subject { last_response }

      its(:status) {should eq 200}
      its(:body) { should have_json_path 'id' }
      its(:body) { should have_json_path 'username' }
      its(:body) { should have_json_path 'email' }
      its(:body) { should have_json_path 'first_name' }
      its(:body) { should have_json_path 'last_name' }
      its(:body) { should have_json_path 'promotion' }
    end
  end

  describe 'promotion resource' do
    describe 'get all promotions' do
      let(:promotions) { FactoryGirl.build_list :promotion, 10, :with_students }
      let!(:request) { get "#{api_host}/promotions?client_id=#{application.uid}&client_secret=#{application.secret}" }

      subject { last_response }

      its(:status) { should be 200 }
      its(:body) { should have_json_path '0/id' }
      its(:body) { should have_json_path '0/name' }
      its(:body) { should have_json_path '0/students/0/id' }
      its(:body) { should have_json_path '0/students/0/username' }
      its(:body) { should have_json_path '0/students/0/email' }
      its(:body) { should have_json_path '0/students/0/first_name' }
      its(:body) { should have_json_path '0/students/0/last_name' }
    end

    describe 'get all promotions' do
      let(:promotion) { FactoryGirl.create :promotion, :with_students }
      let!(:request) { get "#{api_host}/promotions/#{promotion.to_param}?client_id=#{application.uid}&client_secret=#{application.secret}" }

      subject { last_response }

      its(:status) { should be 200 }
      its(:body) { should have_json_path 'id' }
      its(:body) { should have_json_path 'name' }
      its(:body) { should have_json_path 'students/0/id' }
      its(:body) { should have_json_path 'students/0/username' }
      its(:body) { should have_json_path 'students/0/email' }
      its(:body) { should have_json_path 'students/0/first_name' }
      its(:body) { should have_json_path 'students/0/last_name' }
    end
  end
end