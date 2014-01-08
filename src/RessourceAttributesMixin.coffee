debug = require('debug') 'slumber:RessourceAttributesMixin'

"use strict"

callable = (ctor) ->
  callable_ctor = (a...) ->
    obj = -> obj.callable.apply (this ? obj), arguments
    obj.__proto__ = ctor::
    result = ctor.call obj
    if typeof result is 'object' then result
    else obj
  callable_ctor.__proto__ = ctor
  callable_ctor:: = ctor::
  # Copy call() and apply() from Function.prototype to the constructor prototype
  {call: callable_ctor::call, apply: callable_ctor::apply} = Function::
  callable_ctor

getattr = ->
  debug 'getattr'
  {Ressource} = require './Ressource'
  return Ressource

class module.exports.RessourceAttributesMixin
  constructor: ->
    debug 'constructor'
    @getattr = callable getattr
    return @getattr