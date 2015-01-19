require File.expand_path('../spec_helper.rb', __FILE__)

describe User do

  let(:person_hash)do
    {first_name: 'Hassan', last_name: 'Hanafy',
     email: 'has@gmail.com', access_token: 'ACCESS_TOKEN'}
  end

  describe 'User validation' do
    it 'should validate first/last names, email, and access_token' do
      person_hash = {first_name: 'Hassan', last_name: 'Hanafy',
                     email: 'has@gmail.com', access_token: 'ACCESS_TOKEN'}
      User.new(person_hash).should be_valid

      person_hash.keys.each do |key|
        # removing any of the the field invalidates the person
        User.new(person_hash.merge(key => nil)).should_not be_valid
      end
    end
  end
  
  describe 'User creation' do
    it 'should add a new user to db with profile and access_token' do
      User.count.should == 0
      User.create_user_from_fb(person_hash, 'ACCESS_TOKEN')
      User.count.should ==1
    end
  end
   
end
