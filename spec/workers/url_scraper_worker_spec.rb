require 'rails_helper'

describe UrlScraperWorker do
  let(:url) { "www.example.com" } 
  let(:id) { 'unique_id' }

  describe '.perform' do
    subject { described_class.new.perform(id, url) }

    context 'when scraping is successful' do
      before do 
        Timecop.freeze(Time.now)
        allow(UrlScraper).to receive(:meta_info).with(url).and_return(meta_info)
      end

      after do
        Timecop.return
      end

      let(:meta_info) do
        {
          type: 'video.movie',
          title: 'My Profile',
          images: []
        }
      end
  
      let(:data) do
        {
          id: id,
          url: url,
          type: meta_info[:type],
          title: meta_info[:title],
          images: meta_info[:images],
          updated_time: Time.now.utc.iso8601,
          scrape_status: "done"
        }
      end

      it 'saves the meta info' do 
        expect(Story).to receive(:update).with(id, data).once
        subject
      end
    end

    # context 'when scraping is unsuccessful' do
    #   before do 
    #     Timecop.freeze(Time.now)
    #     allow(UrlScraper).to receive(:meta_info).and_raise(StandardError.new("error"))
    #   end

    #   after do
    #     Timecop.return
    #   end

    #   let(:data) do
    #     {
    #       id: id,
    #       updated_time: Time.now.utc.iso8601,
    #       scrape_status: "error"
    #     }
    #   end

    #   it 'saves the meta info' do 
    #     expect(Story).to receive(:update).with(id, data).once
    #     subject
    #   end
    # end
  end
end