require 'rack'
require 'byebug'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'
  if req.path == '/i/love/app/academy'
    res.write(req.path)
  end
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
