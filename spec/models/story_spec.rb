require 'rails_helper'

describe Story do
  let(:url) { "www.example.com" } 

  describe '.create' do
    subject { described_class.create(url) }
    let(:id) { 'unique_id' }

    context 'when url is already present' do
      before do 
        redis.set(url, id)
      end

      it 'returns corresponding id of the url' do 
        expect(subject).to eql(id)
      end
    end

    context 'when url is not present' do
      context 'When relevant canonical tag is present' do
        let(:canonical_url) {"https://www.example.com/canonical" }

        before do
          allow(UrlScraper).to receive(:canonical_url).and_return(canonical_url)
        end
        
        context 'when canonical is present in the system' do
          before do 
            redis.set(canonical_url, "system_stored_id")
          end

          it 'returns id' do
            expect(subject).to eql('system_stored_id')
          end
        end

        context 'when canonical url is not present in the system' do
          before do
            allow(SecureRandom).to receive(:uuid).and_return(id)
            expect(UrlScraperWorker).to receive(:perform_async).once
          end

          it 'creates id and url mapping in redis' do
            subject
            expect(redis.get(canonical_url)).to eql(id)
          end

          it 'returns id' do
            expect(subject).to eql(id)
          end
        end
      end
    end
  end
end
