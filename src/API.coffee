querystring = require 'querystring'
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
      content_type = response.headers['content-type'].split(';')[0].replace(/^\s*|\s*$/g, '')

      try
        stype = @serializer.get_serializer null, content_type
      catch e
        return body

      return stype.loads body

    return body

  _request: (method, kwargs, fn) =>
    request_options =
      url: @base_url
      method: method
      headers:
        accept: @serializer.get_serializer().get_content_type()

    if kwargs.args?
      request_options.url += '?' + querystring.stringify kwargs.args

    if kwargs.data?
      request_options.form = kwargs.data

    debug "#{method}", request_options.url
    req = request request_options, fn

  callable: @::_create_child

  get: (kwargs, fn) =>
    if 'function' is typeof kwargs
      fn = kwargs
      kwargs = {}
    else
      unless kwargs.args?
        kwargs = args: kwargs

    handle = (err, response, body) =>
      if 200 <= response.statusCode <= 299
        return fn err, @_try_to_serialize response, body
      else
        return fn true

    resp = @_request 'GET', kwargs, handle

  delete: (kwargs, fn) =>
    if 'function' is typeof kwargs
      fn = kwargs
      kwargs = {}
    else
      unless kwargs.args?
        kwargs = args: kwargs

    handle = (err, response, body) =>
      if 200 <= response.statusCode <= 299
        if response.statusCode == 204
          return fn err, true
        else
          return fn err, true
      else
        return fn true, false

    resp = @_request 'DELETE', kwargs, handle

  post: (kwargs, fn) =>
    unless 'args' in kwargs
      kwargs = data: kwargs

    handle = (err, response, body) =>
      if 200 <= response.statusCode <= 299
        return fn err, @_try_to_serialize response, body
      return fn true

    resp = @_request 'POST', kwargs, handle

  put: (kwargs, fn) =>
    unless 'args' in kwargs
      kwargs = data: kwargs

    handle = (err, response, body) =>
      if 200 <= response.statusCode <= 299
        return fn err, @_try_to_serialize response, body
      return fn true

    resp = @_request 'PUT', kwargs, handle

  patch: (kwargs, fn) =>
    unless 'args' in kwargs
      kwargs = data: kwargs

    handle = (err, response, body) =>
      if 200 <= response.statusCode <= 299
        return fn err, @_try_to_serialize response, body
      return fn true

    resp = @_request 'PATCH', kwargs, handle


module.exports = API
