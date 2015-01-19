require File.expand_path('../spec_helper.rb', __FILE__)

# i need to overwrite it
disable :sessions

describe 'authentication with facebook' do
  before(:each) do

    fb_profile = {'first_name' => 'Hassan',
                  'last_name' => 'Hanafy',
                  'email' => 'hassan@gmail.com', 
                  'id' => '123456'}

    Koala::Facebook::API.any_instance.stub(:get_object).with('me').
                                                      and_return(fb_profile)
  end

  let(:oauth) do
    oauth_double = double('oauth_double')

    allow(oauth_double).to receive(:get_access_token).with('CODE').
                                                  and_return('ACCESS_TOKEN')
    oauth_double
  end

  it 'should add user to db if non exists' do 
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    expect(User.count).to eq(1)
    expect(User.first.first_name).to eq('Hassan')
    expect(User.first.last_name).to eq('Hanafy')
    expect(User.first.email).to eq('hassan@gmail.com')
    expect(User.first.access_token).to eq('ACCESS_TOKEN')
    expect(User.first.fb_id).to eq('123456')
  end

  it 'should put the user_id in the session' do
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    expect(session['current_user'].id).to eq(User.first.id)
  end

  it 'should be able to logout' do
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    get '/logout'
    expect(session['current_user']).to be_nil
    expect(last_response).to be_redirect
    expect(last_response.location).to eq('http://example.org/')
  end

  it 'should not add a new user for the same email' do
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    get '/logout'
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    expect(User.count).to eq(1)
    expect(session['current_user'].id).to eq(User.first.id)
  end
end
