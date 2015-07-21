require 'spec_helper'

describe 'Authorization' do
  context 'when not logged in' do
    it 'should not allow access to manage' do
      visit '/manage'
      expect(page.status_code).to be(401)
    end

    it 'should not allow access to the create form' do
      visit '/new'
      expect(page.status_code).to be(401)
    end

    it 'should not allow access to send' do
      visit '/send'
      expect(page.status_code).to be(401)
    end

    it 'should not allow access to delete' do
      visit '/destroy'
      expect(page.status_code).to be(401)
    end
  end

  it 'should allow accessing the home page' do
    visit '/'
    expect(page.status_code).to be(200)
  end

  it 'should allow accessing the events page' do
    visit '/events'
    expect(page.status_code).to be(200)
  end

  context 'when logging in' do
    context 'with incorrect credentials' do
      before(:each) { basic_auth 'baduser', 'badpassword' }

      it 'should allow not allow access' do
        visit '/manage'
        expect(page.status_code).to be(401)
      end
    end

    context 'with correct credentials' do
      before(:each) { basic_auth 'admin', 'password' }

      it 'should allow access' do
        visit '/manage'

        expect(page.status_code).to be(200)
      end
    end
  end
end
