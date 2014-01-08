debug = require('debug') 'slumber:utils'


module.exports.callable = (ctor) ->
  callable_ctor = (a...) ->
    obj = ->
      obj.callable.apply obj, arguments
    obj.__proto__ = ctor::
    result = ctor.call obj, a...
    if typeof result is 'object'
      return result
    else
      return obj

  callable_ctor.__proto__ = ctor
  callable_ctor:: = ctor::
  {call: callable_ctor::call, apply: callable_ctor::apply} = Function::

  return callable_ctor


module.exports.append_slash = (str) ->
  str.replace(/\/$/, '') + '/'
