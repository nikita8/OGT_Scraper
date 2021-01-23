# Open Graph Tags Scraper

Open Graph Tags Scraper is a web service that allows user to get the meta and image open graph tag info of the webpage.

## Requirements

* Ruby 2.7
* Rails 6.1.1
* Redis 6

## Getting Started

Install the gem:

```bash
  bundle install
```

Start the sidekiq server:

```bash
  bundle exec sidekiq
```

Start the application server:

```bash
  bundle exec rails s
```

## Features

* POST `localhost:3000/stories?url={some_url}`

  Responses:

  | Response Code | Response body|
  |---------------|--------------|
  | 200 | `{ id: "e4d0c894-c84a-4d20-b49c-1525ed6b245c" }`|
  | 400 | `{ status: "error", message: "'url' is missing"}`|
  | 500 | `{ status: "error", message: "Something went wrong"}`|

* GET `localhost:3000/stories/:id`

  Responses:

  | Response Code | Response body|
  |---------------|--------------|
  | 200 | `{"id": "e4d0c894-c84a-4d20-b49c-1525ed6b245c", "url": "http://ogp.me/", "type": "website", "title": "Open Graph protocol", "images": [{"url": "http://ogp.me/logo.png","type": "image/png","width": 300,"height": 300,"alt": "The Open Graph logo"}],"updated_time": "2018-02-18T03:41:09+0000","scrape_status": "done"}`|

  Note: 
 `scrape_status` field can be either `done`, `error` or `pending`

## Curl Example

POST request:
`curl -X POST "localhost:3000/stories?url=http://ogp.me"`

For successfull request, it returns id.
For eg: {id: "e4d0c894-c84a-4d20-b49c-1525ed6b245c"}
This id will be used in the get request url to retrieve the meta and image tag info.

GET meta info:
`curl localhost:3000/stories/e4d0c894-c84a-4d20-b49c-1525ed6b245c`

## Running tests
1. Start Redis.

     Using docker: 
     ```bash
     docker run --rm -p 6379:6379 redis
     ```
2. Install dependencies.
   ```bash
   bundle install
   ```
3. Run tests.
   ```bash
   bundle exec rspec
   ```
