# Marvel app

This README documents the Marvel api challenge.

## Functionality
```
- As a user, I am redirected to the root page
- As a user, I can see a list of comics or a refresh button
- As a user, I can navigate through the pages listing comics
- As a user, I can upvote a comic with a favorite button
- As a user, I can search for comic's characters
```

## App description
```
- This is a Rails 7 monolith app
- It handles external API calls with httparty gem
- The Marvel API elements are wrapped in a module to be reused in different requests
- The Marvel API request is encapsulated in a service object
- To improve performance the API's response is cached using loew-level caching technique
- The favorite/upvote logic is done with cookies to avoid implementing a more robust authentication system
- The app has test coverage built with Rspec gem
```

## Dependencies
```
- Rspec
- httparty
- dotenv-rails
- will_paginate
- webmock
```

## Running the app
Clone this repo:
```
$ git clone git@github.com:{USER_NAME}/street-bees-challenge.git
```
Install all dependancies:
```
$ bundle install
```
Start the server:
```
$ rails server
```

## Running tests
```
$ bundle exec rspec
```

## Acknowledgments
```
- The layout is not fully responsive
- The caching system stores data in memory, which in a commercial app wouldn't be a good practice. Redis is a better solution
- The strategy to prevent timeout errors is to return an empty array allowing the user to refresh the request. A better solution would be turbo lazy-loading, that could also reduce the loading time on the first request 
```
