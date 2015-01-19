require File.expand_path('../spec_helper.rb', __FILE__)

# i need to overwrite it
disable :sessions

describe 'authentication with facebook' do
  before(:each) do

    fb_profile = {'first_name' => 'Hassan',
                  'last_name' => 'Hanafy',
                  'email' => 'hassan@gmail.com'}

    Koala::Facebook::API.any_instance.stub(:get_object).with('me').
                                                      and_return(fb_profile)
  end

  let(:oauth) do
    o = double('oauth_double')

    allow(o).to receive(:get_access_token).
      with('CODE').
      and_return('ACCESS_TOKEN')
    o
  end

  it 'should add user to db if non exists' do 
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    expect(User.count).to eq(1)
    expect(User.first.first_name).to eq('Hassan')
    expect(User.first.last_name).to eq('Hanafy')
    expect(User.first.email).to eq('hassan@gmail.com')
    expect(User.first.access_token).to eq('ACCESS_TOKEN')
  end

  it 'should put the user_id in the session' do
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    expect(session['current_user'].id).to eq(User.first.id)
  end

  it 'should be able to logout' do
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    get '/logout'
    expect(session['current_user'].nil?).to eq(true)
  end

  it 'should not add a new user for the same email' do
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    get '/logout'
    get '/callback', {code: 'CODE'}, 'rack.session' => {'oauth' =>  oauth}
    expect(User.count).to eq(1)
    expect(session['current_user'].id).to eq(User.first.id)
  end
end
