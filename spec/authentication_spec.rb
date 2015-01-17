require File.expand_path('../spec_helper.rb', __FILE__)

describe 'authentication with facebook' do
  before(:each) do
    Koala::Facebook::OAuth.any_instance.stub(:get_access_token).
                                    with(any_args).and_return('ACCESS_TOKEN')

    fb_profile = {first_name: 'Hassan',
                  last_name: 'Hanafy',
                  email: 'hassan@gmail.com'}

    Koala::Facebook::API.any_instance.stub(:get_object).with('me').
                                                      and_return(fb_profile)
    
  end

  it 'should add user to db if non exists' do 
    get '/callback?code=CODE'
    User.count.should == 1
    User.first.first_name.should == 'Hassan'
    User.first.last_name.should == 'Hanafy'
    User.first.email.should == 'hassan@gmail.com'
    User.first.access_token.should == 'ACCESS_TOKEN'
  end

  it 'should put the user_id in the session' do
    get '/callback?code=CODE'
    session[:user_id].should == User.first.id
  end

  it 'should be able to logout' do
    get '/callback?code=CODE'
    get '/logout'
    session[:user_id].should_not == User.first.id
  end

  it 'should not add a new user for the same email' do
    get '/callback?code=CODE' # make the first user
    get '/logout'
    get '/callback?code=CODE' # make the first user
    User.count.should == 1
    session[:user_id].should == User.first.id
  end
end
