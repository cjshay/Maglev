require 'erb'

class ShowExceptions
  def initialize(app)
    @app = app
  end

  def call(env)

    @app(env)
  end

  private

  def render_exception(e)
     
  end

end
