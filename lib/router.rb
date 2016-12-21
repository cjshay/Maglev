class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name
# pattern, http_method, controller_class, action_name
  def initialize(route_options)
    @pattern = route_options[:pattern]
    @http_method = route_options[:method]
    @action_name = route_options[:action_name]
    @controller_class = route_options[:controller_class]
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)
    regex = Regexp.new(pattern)
    match_data = regex.match(req.path)
    if http_method.to_s.upcase == req.request_method && match_data
      match_data
    else
      nil
    end
  end

  # use pattern to pull out route params (save for later?)
  # instantiate controller and call controller action
  def run(req, res)
    params = {}
    matches = matches?(req)
    if matches
      matches.names.each { |name| params[name] = matches[name] }
    end
    @controller_class.new(req, res, params).invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    route_info = {
      pattern: pattern,
      method: method,
      controller_class: controller_class,
      action_name: action_name}
    routes << Route.new(route_info)
  end

  # evaluate the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
    self.instance_eval(&proc)
  end

  # make each of these methods that
  # when called add route
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # should return the route that matches this request
  def match(req)
    routes.find { |route| route.matches?(req) }
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
    route = match(req)
    if route
      route.run(req, res)
    else
      res.status = 404
      res.body = ["#{req.request_method} Route for #{req.path} does not exist in the router"]
    end
  end
end
