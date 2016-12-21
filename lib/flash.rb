require 'json'

class Flash
  attr_reader :now
  def initialize(req)
    cookie = req.cookies['maglev_flash']
    if cookie
      @now = JSON.parse(cookie)
    else
      @now = {}
    end

    @flash = {}
  end

  def [](key)
    @now[key] || @flash[key]
  end

  def []=(key, val)
    @flash[key.to_s] = val
  end

  def store_flash(res)
    res.set_cookie('maglev_flash', value: @flash.to_json, path: '/')
  end
end
