require File.expand_path('../spec_helper.rb', __FILE__)

# i need to overwrite it
disable :sessions

describe 'authentication with facebook' do
  before(:each) do

    fb_profile = {first_name: 'Hassan',
                  last_name: 'Hanafy',
                  email: 'hassan@gmail.com'}

    Koala::Facebook::API.any_instance.stub(:get_object).with('me').
                                                      and_return(fb_profile)
  end

  let(:oauth) do
    double('oauth_double', get_access_token: 'ACCESS_TOKEN')
  end

  it 'should add user to db if non exists' do 
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    User.count.should == 1
    User.first.first_name.should == 'Hassan'
    User.first.last_name.should == 'Hanafy'
    User.first.email.should == 'hassan@gmail.com'
    User.first.access_token.should == 'ACCESS_TOKEN'
  end

  it 'should put the user_id in the session' do
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    session['current_user'].id.should == User.first.id
  end

  it 'should be able to logout' do
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    get '/logout'
    session['current_user'].should  be_nil
  end

  it 'should not add a new user for the same email' do
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    get '/logout'
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    User.count.should == 1
    session['current_user'].id.should == User.first.id
  end
end
