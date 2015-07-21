require 'spec_helper'

describe Link do
  let(:link) { build(:link) }

  context 'with valid data' do
    it 'should be valid' do
      expect(link).to be_valid
    end
  end

  context 'with invalid data' do
    it 'should not be valid with blank title' do
      link.title = ''

      expect(link).to be_invalid
    end

    it 'should not be valid with a blank url' do
      link.url = ''

      expect(link).to be_invalid
    end

    it 'should not be valid with a bad url' do
      link.url = 'bad'

      expect(link).to be_invalid
    end

    it 'should not be valid with a duplicate url' do
      create(:link, url: link.url)

      expect(link).to be_invalid
    end
  end

  context '#mark_sent' do
    it 'should set a time to sent_at' do
      link.mark_sent

      expect(link.sent_at).to_not be(nil)
    end
  end

  context '#sent?' do
    context 'when already sent' do
      it 'should respond with true' do
        link.mark_sent
        expect(link.sent?).to be(true)
      end

      it 'should respond with false' do
        expect(link.sent?).to be(false)
      end
    end
  end

  context '#url' do
    it 'removes a trailing slash' do
      link.url = 'http://www.url.com/'
      expect(link.url).to eq('http://www.url.com')
    end
  end
end
