require 'rails_helper'
require './lib/url_scraper'

describe Parser do
  describe '#call' do
    before do
      allow(URI).to receive(:open).and_return(file_fixture("test.html"))
    end

    it 'returns site_name meta information from website' do
      parser = Parser.new("wwww.example.com")
      expect(parser.call('site_name', 0)).to eql('example')
    end
  end
end

describe UrlScraper do
  let(:url) { "www.example.com" } 

  describe '.canonical_url' do
    subject { described_class.canonical_url(url) }

    context 'When relevant canonical tag is present' do
      before do
        allow(URI).to receive(:open).and_return(file_fixture("test_canonical.html"))
      end

      it 'returns canonical_url' do
        expect(subject).to eql('https://www.example.com/canonical')
      end
    end

    context 'When relevant canonical tag is absent' do
      before do
        allow(URI).to receive(:open).and_return(file_fixture("test.html"))
      end

      it 'returns og:url value' do
        expect(subject).to eql('https://www.example.com/')
      end
    end
  end

  describe '.meta_info' do
    subject { described_class.meta_info(url) }

    context 'When relevant meta tag is present' do
      let(:images_tag) do
        [
          { 
            url: 'https://www.example.com/images/fb_icon_325x325.png',
            type: 'image/jpeg',
            width: '400',
            height: '300',
            alt: 'Facebook Icon'
          },
          { 
            url: 'https://www.example.com/images/fb_icon1_325x325.png',
            type: 'image/jpeg',
            width: '400',
            height: '300',
            alt: 'Facebook Icon1'
          },
        ]
      end
      let(:meta_info) do
        {
          type: 'video.movie',
          title: 'My Profile',
          images: images_tag
        }
      end

      before do
        allow(URI).to receive(:open).and_return(file_fixture("test.html"))
      end

      it 'returns meta and images tag info' do
        expect(subject).to eql(meta_info)
      end
    end
  end
end
