# README

## Comic App

Hi, this is the README for my comic app implementation. I'll try to explain the most relevant decisions in here.

### Architecture

I tried to organize my code in a way that it could be flexible, easy to read and understand.
To do that I tried to follow the port and adapters architecture (hexagonal architecture).

https://medium.com/idealo-tech-blog/hexagonal-ports-adapters-architecture-e3617bcf00a0

My project has two basic ports which are: Routes.rb file that deals with http coming into the service and routes to a specific handler. And http_out port which deals with http going outside of the service.

So basically, when you request for /comics endpoint it will reach the routes port and be handled by ComicsController. I tried to use dependency injection in order to make the code flexible and not bounded to a specific implementation. Inside the comics controller handler, I instantiate the dependencies for the ComicService, the class that is responsible to orchestrate the feature of retrieving the comics correctly.

The ComicService just need a http_component to be injected in order to work and the http_component needs and adapter to work as an anti-corruption-layer. This way it's flexibe, for example, to create a new http_component to deal with DC comics API for example and use the same ComicService to orchestrate all the necessary behaviour.

To summarize, I have four basic types of classes: Services, port handlers (controllers and http_components), adapters and domain classes.

Also, everyting is under the comic module. This way it's possible to make the application more modular and create a specific module for dc_comic for example and deal with different providers altogether.

### Tests

I used Rspec to test my code, so in order to run the tests just run "bundle exec rspec"

I created unit tests for adapters, entities and http components.
I created integration tests to validate the whole flow starting from the controller

### Features

 - When I open the page I want to see a list of all Marvel’s released comic books covers ordered from most recent to the oldest.

  -- Just access "https://comic-app-mesq.herokuapp.com" and it will be able to see comic books covers ordered.

 - When I see the list of comics I want to be able to search by character (eg. “deadpool”)
so I can find my favorite comics.

  -- Just type in the input text the character name and wait a second to debounce work and search for the appropriate character.

 - When I see the list of comics I want to be able to upvote any of them so that the most
popular are easy to find in the future

  -- Just put the mouse over the comic, click on the hear to upvote and click again to downvote. The side effects are being recorded for the user during 30 minutes in redis. So if you update the page the upvoted will still appear.

### How to run

To test the application I decided to upload this to Heroku, here's the link:
https://comic-app-mesq.herokuapp.com

If you want to run locally you can just run "bundle install" + "rails s" and test locally. I didn't commit the .env file but I'll send in the zip in case you want to test locally.

### libs

 - dry-struct
  It's a library to define immutable structs and have type validations on it. Instead of using ActiveModel I prefer to define simple immutable structures to be used as entities.

 - dry-validation
  I wanted to use dry validation to check the contract between my service and Marvel's API. But I decided not to use and not add more complexity to the test. I think it's a really necessary feature in production, but for this test I decided not to use it.

 - rest-client
  It's a library to make http calls to marvel's API.

 - rubocop
  It's a library to enforce code style.

 - pry
  I used a lot to debug some issues.
