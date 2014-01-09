debug = require('debug') 'slumber:api'
{callable, append_slash} = require './utils'
request = require 'request'
{Serializer} = require './Serializer'

API = callable class
  constructor: (base_url, @opts={}, fn=null) ->
    debug "constructor base_url=#{base_url}"

    if base_url?
      @opts.base_url = base_url
    @opts.append_slash ?= true
    @opts.session ?= null
    @opts.auth ?= null

    @opts.format ?= 'json'
    @serializer = @opts.serializer ?= new Serializer @opts.format

    if @opts.append_slash
      @opts.base_url = append_slash @opts.base_url
    @base_url = @opts.base_url

    unless @opts.base_url
      throw "base_url is required"

    #unless session
      # handle auth

    process.nextTick -> fn @ if fn
    return @

  _create_child: (path) =>
    new_base_url = "#{append_slash @base_url}#{path}"

    callable_api = API
    child = new callable_api new_base_url, @opts
    return child

  _try_to_serialize: (response, body) =>
    if response.headers['content-type']?
      content_type = response.headers['content-type']

      try
        stype = @serializer.get_serializer null, content_type
      catch e
        return body

      return stype.loads body

    return body

  _request: (method, args, fn) =>
    debug "#{method}", args
    request_options =
      url: @base_url
      method: method
      headers:
        accept: @serializer.get_serializer().get_content_type()
    req = request request_options, fn

  callable: @::_create_child

  get: (args..., fn) =>
    handle = (err, response, body) =>
      if 200 <= response.statusCode <= 299
        return fn err, @_try_to_serialize response, body
      else
        return fn true
    resp = @_request 'GET', args, handle

  post: -> debug 'post', @base_url
  patch: -> debug 'path'
  put: -> debug 'put'
  delete: -> debug 'delete'

module.exports = API
