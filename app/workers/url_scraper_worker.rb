class UrlScraperWorker
  include Sidekiq::Worker

  def perform(id, url)
    begin
      meta_info = UrlScraper.meta_info(url)
      data = {
        id: id,
        url: url,
        type: meta_info[:type],
        title: meta_info[:title],
        images: meta_info[:images],
        updated_time: Time.now.utc.iso8601,
        scrape_status: "done"
      }
      Story.update(id, data)
    rescue => e
      Rails.logger.error(e)
      data = {
        id: id, 
        updated_time: Time.now.utc.iso8601,
        scrape_status: "error"
      }
      Story.update(id, data)
    end
  end
end