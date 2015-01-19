require File.expand_path('../spec_helper.rb', __FILE__)

describe 'Landing page' do

  it 'should render layout including Foinz' do
    get '/'
    expect(last_response.body).to include('Foinz')
  end
end
