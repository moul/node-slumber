debug = require('debug') 'slumber:Ressource'
{RessourceAttributesMixin} = require './RessourceAttributesMixin'


class module.exports.Ressource extends RessourceAttributesMixin
  constructor: ->
    debug 'constructor'
    super
    return @getattr