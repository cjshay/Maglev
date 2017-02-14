require 'rack'
require_relative '../lib/controller_base.rb'
require_relative '../lib/router'

class Band
  attr_reader :name, :frontman

  def self.all
    @bands ||= []
  end

  def initialize(params = {})
    params ||= {}
    @name, @frontman = params["name"], params["frontman"]
  end

  def errors
    @errors ||= []
  end

  def valid?
    unless @frontman.present?
      errors << "Frontman can't be blank"
      return false
    end

    unless @name.present?
      errors << "Name can't be blank"
      return false
    end
    true
  end

  def save
    return false unless valid?

    Band.all << self
    true
  end

  def inspect
    { name: name, frontman: frontman }.inspect
  end
end

class BandsController < ControllerBase
  def create
    @band = Band.new(params["band"])
    if @band.save
      flash[:notice] = "Saved band successfully"
      redirect_to "/bands"
    else
      flash.now[:errors] = @band.errors
      render :new
    end
  end

  def index
    @bands = Band.all
    render :index
  end

  def new
    @band = Band.new
    render :new
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/bands$"), BandsController, :index
  get Regexp.new("^/bands/new$"), BandsController, :new
  get Regexp.new("^/bands/(?<id>\\d+)$"), BandsController, :show
  post Regexp.new("^/bands$"), BandsController, :create
end

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
