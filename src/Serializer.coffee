class BaseSerializer
  content_types: null
  key: null

  constructor: ->
    @debug = require('debug') "slumber:#{@constructor.name}"
    @debug 'constructor'

  get_content_type: =>
    unless @content_types?
      throw 'Not Implemented'
    return @content_types[0]

  loads: (data) =>
    throw 'Not Implemented'

  dumps: (data) =>
    throw 'Not Implemented'


class JsonSerializer extends BaseSerializer
  content_types: [
    'application/json'
    'application/x-javascript'
    'text/javascript'
    'text/x-javascript'
    'text/x-json'
    ]
  key: 'json'

  loads: (data) =>
    return JSON.parse data

  dumps: (data) =>
    return JSON.stringify data


class YamlSerializer extends BaseSerializer
  content_types: [
    'text/yaml'
    ]
  key: 'yaml'
  # TODO: implements


SERIALIZERS = module.exports.SERIALIZERS =
  'json': JsonSerializer
  'yaml': YamlSerializer


class module.exports.Serializer
  constructor: (@default='json', serializers=null) ->
    unless serializers?
      serializers = [new obj for key, obj of SERIALIZERS][0]

    unless serializers
      throw 'There are no available serializers.'

    @serializers = {}
    for serializer in serializers
      @serializers[serializer.key] = serializer

  get_serializer: (name=null, content_type=null) =>
    # TODO: dynamic
    return @serializers[@default]

  loads: (data, format=null) =>
    s = @get_serializer format
    return s.loads data

  dumps: (data, format=null) =>
    s = @get_serializer format
    return s.dumps data

  get_content_type: (format=null) =>
    s = @get_serializer format
    return s.get_content_type()
