require 'rack'
require_relative '../lib/controller_base'

class MyController < ControllerBase
  def go
    session["count"] ||= 0
    session["count"] += 1
    render :counting_show
  end
end

class LoggerMiddleware
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    write_log(env)
    app.call(env)
  end

private
  def write_log(env)
    req = Rack::Request.new(env)
    log_file = File.open('application.log', 'a')

    log_text = <<-LOG
    Time: #{Time.now}
    IP: #{req.ip}
    PATH: #{req.path}
    User Agent: #{req.user_agent}
    LOG
    log_file.write(log_text)
    log_file.close
  end
end

cat_app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  MyController.new(req, res).go
  res.finish
end

app = Rack::Builder.new do
  use LoggerMiddleware
  run cat_app
end.to_app

Rack::Server.start(
  app: app,
  Port: 3000
)
