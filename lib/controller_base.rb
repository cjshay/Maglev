require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'
require 'byebug'
require 'active_support/inflector'




class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = req.params.merge(route_params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
  end

  # Set the response status code and header
  def redirect_to(url)
    @already_built_response = true
    session.store_session(res)

    res.location = url
    res.status = 302
    flash.store_flash(res)
    res
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    @already_built_response = true
    session.store_session(res)

    res.write(content)
    res['content_type'] = content_type
    flash.store_flash(@res)
    res
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    file_text = File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    content = ERB.new("#{file_text}").result(binding)
    render_content(content, 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    # if lash
  end
end
