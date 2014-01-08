debug = require('debug') 'slumber:api'
{callable, append_slash} = require './utils'


class API
  constructor: (base_url, @opts={}, fn=null) ->
    debug "constructor base_url=#{base_url}"

    if base_url?
      @opts.base_url = base_url
    @opts.append_slash ?= true
    @opts.session ?= null
    @opts.auth ?= null
    @opts.format ?= 'json'
    @opts.serializer ?= null
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

    callable_api = callable API
    child = new callable_api new_base_url, @opts
    return child

  callable: @::_create_child

  get: -> debug 'get'
  post: -> debug 'post'
  patch: -> debug 'path'
  put: -> debug 'put'
  delete: -> debug 'delete'

module.exports = callable API
