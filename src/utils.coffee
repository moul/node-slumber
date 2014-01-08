debug = require('debug') 'slumber:utils'

"use strict"

module.exports.callable = (ctor) ->
  callable_ctor = (a...) ->
    obj = ->
      obj.callable.apply obj, arguments
    obj.__proto__ = ctor::
    result = ctor.call obj, a...
    if typeof result is 'object' then result
    else obj
  callable_ctor.__proto__ = ctor
  callable_ctor:: = ctor::
  # Copy call() and apply() from Function.prototype to the constructor prototype
  {call: callable_ctor::call, apply: callable_ctor::apply} = Function::
  callable_ctor

module.exports.append_slash = (str) ->
  str.replace(/\/$/, '') + '/'
