class Story
  def self.create(url)
    # check if url already exists
    if id = url_id(url)
      return id 
    end
    
    # find canonical url and check if url already exists
    canonical_url = find_canonical_url(url)
    return unless canonical_url

    if id = url_id(canonical_url) 
      return id 
    end
    
    generate_url_id(canonical_url)
  end  

  def self.find(id)
    redis.get(id)
  end

  def self.update(id, data)
    redis.set(id, data)
  end

  private
  def self.generate_id
    SecureRandom.uuid 
  end

  def self.generate_url_id(url)
    id = generate_id
    redis.set(url, id)
    data = {"updated_time": Time.now.utc.iso8601, scrape_status: "pending"}
    redis.set(id, data)
    UrlScraperWorker.perform_async(id, url)
    id
  end

  def self.find_canonical_url(url)
    begin
      url = UrlScraper.canonical_url(url)
    rescue => e 
      Rails.logger.error e
      return False
    end
  end

  def self.url_id(url)
    redis.get(url)
  end
end
