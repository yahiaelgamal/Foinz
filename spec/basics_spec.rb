require File.expand_path('../spec_helper.rb', __FILE__)

describe 'Landing page' do

  it 'should render layout including Foinz' do
    get '/'
    last_response.body.include?('Foinz').should be_true
  end
end
