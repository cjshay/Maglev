##Maglev

####Introduction

Maglev is a basic framework that allows users to construct an RESTful
web application. Rack allows Maglev to manipulate the response and requests
that are communicated between the Puma server and the user's client/browser.
Maglev allows users to create classes for application logic, controllers for
routing logic, and views for presentation structure. This is not connected
to an ORM, and so data will not persist between sessions.

####Demo
In order to run the demo:

- Download/Clone this repository
- Bundle Install (ruby gems)
- Run the demo file using the command 'ruby demo/maglev_demo.rb'
- Navigate to http://localhost:3000/ and create bands!

####Use for your own application
To use this framework to run an application, follow these simple steps!

- Download/clone this repository.

- Bundle install the ruby gems

- Create model files in the models folder that handle logic for each
piece of your app (using OOP).

  - For each model, create ::all, #initialize, #valid?, #save, and #inspect
  methods that model the Band class in the demo/maglev_demo.rb file. Add
  any logic that is particular to your application (necessary variables to
  store state, etc)

- Create controller files in the controllers class, to handle state-storing
logic.

  - For each controller, create a class that inherits from the ControllerBase class
  in the lib/controller_base.rb file (make sure you require the controller_base.rb file).

  - Your controller's methods will use the corresponding model in order to store temporary state
  (make sure to require the corresponding model in your controller). I've followed
  rails conventions in the BandsController (:new, :create, etc) but as long as they
  match your routes, the logic will still work.

- Create View folders that match the names of your controllers (from camel case
  to snake case):

  BandsController => /bands_controller

  The views should handle your presentation logic in HTML and use erb to
  communicate with your model. These files should correspond to the controller methods
  that you want physical pages for (ie. index and new). These conventions are
  demonstrated in the views/bands_controller folder.
  
- Create a routes file that handles routes and starting the server

  - Your routes file should require rack ("require 'rack') and the router file
  ("require 'lib/router.rb'").

  - Create a new router and draw routes that match your corresponding controller methods. Use
  Regex to illustrate what paths you want your routes to have. This should look very similar to the
  demo file.

  ```ruby
  router = Router.new
  router.draw do
    get Regexp.new("^/$"), BandsController, :index
    get Regexp.new("^/bands$"), BandsController, :index
    get Regexp.new("^/bands/new$"), BandsController, :new
    get Regexp.new("^/bands/(?<id>\\d+)$"), BandsController, :show
    post Regexp.new("^/bands$"), BandsController, :create
  end
  ```

  - Write the code that instantiates your application server and web server
  using rack. This should look very similar to the demo file.

  ```ruby
    app = Proc.new do |env|
      req = Rack::Request.new(env)
      res = Rack::Response.new
      router.run(req, res)
      res.finish
    end

    Rack::Server.start(
     app: app,
     Port: 3000
    )
  ```


####Future Direction
I really enjoyed creating a framework in order to understand the HTTP request/
response cycle more fully. I plan to continue to work on this project and build it out.

- Merge with an ORM lite project.
If I make a lite version of ActiveRecord, the data that is used in the applications
on maglev can persist using a database.

- Continue to provide helpful tools to allow users easier application creation
I plan to handle regex's on the framework side, so that users don't have to
create regex's in order to make routes for easier usability.
