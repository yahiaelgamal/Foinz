require File.expand_path('../spec_helper.rb', __FILE__)

describe User do

  let(:person_hash) do
    {'first_name' => 'Hassan', 'last_name' => 'Hanafy',
     'email' => 'has@gmail.com', 'access_token' => 'ACCESS_TOKEN',
     'fb_id' => '12345'}
  end

  let(:facebook_profile) do
    {'first_name' => 'Hassan', 'last_name' => 'Hanafy',
     'email' => 'has@gmail.com', 'access_token' => 'ACCESS_TOKEN',
     'id' => '12345'}
  end

  describe 'User validation' do
    it 'should validate first/last names, email, and access_token' do
      expect(User.new(person_hash).valid?).to eq(true)

      person_hash.keys.each do |key|
        # removing any of the the field invalidates the person
        expect(User.new(person_hash.merge(key => nil)).valid?).to_not eq(true)
      end
    end
  end
  
  describe 'User creation' do
    it 'should add a new user to db with profile and access_token' do
      expect(User.count).to eq(0)
      User.create_user_from_fb(facebook_profile, 'ACCESS_TOKEN')
      expect(User.count).to eq(1)
    end
  end
   
end
