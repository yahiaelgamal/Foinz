require File.expand_path('../spec_helper.rb', __FILE__)

describe 'Landing page' do
  it 'should give me hello world' do
    get '/'
    last_response.body.include?('Hello, World!').should be_true
  end


  it 'should render layout' do
    get '/'
    last_response.body.include?('Foinz').should be_true
  end
end
