require 'json'

class Flash
  attr_reader :now

  def initialize(req)
    cookie = req.cookies['_maglev_flash']

    if cookie
      @now = JSON.parse(cookie)
    else
      @now = {}
    end

    @flash = {}
  end

  def [](key)
    @now[key.to_s] || @flash[key.to_s]
  end

  def []=(key, value)
    @flash[key.to_s] = value
  end

  def store_flash(res)
    res.set_cookie('_maglev_flash', value: @flash.to_json, path: '/')
  end
end
