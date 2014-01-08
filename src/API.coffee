debug = require('debug') 'slumber:API'
{RessourceAttributesMixin} = require './RessourceAttributesMixin'
{Ressource} = require './Ressource'


class module.exports.API extends RessourceAttributesMixin
  constructor: (@url, @opts, fn) ->
    debug 'constructor'
    super
    process.nextTick -> fn @
    return @getattr
