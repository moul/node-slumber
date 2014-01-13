#!/usr/bin/env coffee

querystring = require 'querystring'
url = require 'url'
assert = require 'assert'
express = require 'express'
freeport = require 'freeport'

slumber = require '..'

base_url = 'http://www.example.com/'


CUSTOMERS =
  1:
    user: 'Alfred'
    gender: 'male'
    age: 24
  2:
    user: 'George'
    gender: 'male'
    age: 42
  3:
    user: 'Cynthia'
    gender: 'female'
    age: 28


app = express()

app.get '/', (req, res) ->
   res.end 'Hello World !'

app.get '/customers', (req, res) ->
  url_parts = url.parse req.url
  query = querystring.parse url_parts.query

  ret = []
  for customer_id, customer of CUSTOMERS
    ok = true
    for filter_key, filter_value of query
      if customer[filter_key] != filter_value
        ok = false
        break
    if ok
      ret.push customer_id

  res.json ret

app.get '/customers/:id', (req, res) ->
  res.json CUSTOMERS[parseInt req.params.id]


describe 'Routing', ->
  api = slumber.API base_url, {}
  describe '#base_url', ->
    it 'should retrieve a string with base_url of api', ->
      assert.equal api.base_url, base_url

  describe 'one child', ->
    it 'should retrieve a string with base_url of api with 1 child', ->
      assert.equal api('customers').base_url, "#{base_url}customers/"

  describe 'two children', ->
    it 'should retrieve a string with base_url of api with 2 children', ->
      assert.equal api('customers')(42).base_url, "#{base_url}customers/42/"


describe 'Serializer', ->
  describe 'serializer', ->
    api = slumber.API base_url, {}
    it 'should be an object', ->
      assert.equal 'object', typeof api.serializer

    describe '#serializers', ->
      it 'should return an array of available serializers', ->
        assert.equal 'object', typeof api.serializer.serializers

    describe '#get_serializer()', ->
      it 'should return the default serializer', ->
        serializer = api.serializer.get_serializer()
        assert.equal 'object', typeof serializer
        assert.equal 'json', serializer.key

    describe '#get_by_name', ->
      it 'should return the best serializer depending on name', ->
        assert.equal 'yaml', api.serializer.get_serializer('yaml').key

    describe '#get_by_content_type', ->
      it 'should return the best serializer depending on content-type', ->
        mapping =
          'text/yaml': 'yaml'
          'application/json': 'json'
          'application/x-javascript': 'json'
          'text/javascript': 'json'
          'text/x-javascript': 'json'
          'text/x-json': 'json'
          'dontexists': null
        for k, v of mapping
          if v is null
            assert.throws (-> api.serializer.get_serializer(null, k)), /there is no available serializer for content-type/
          else
            assert.equal v, api.serializer.get_serializer(null, k).key

  describe 'YamlSerializer', ->
    api = slumber.API base_url, {'format': 'yaml'}
    serializer = api.serializer.get_serializer()

    describe '#constructor', ->
      it 'should be a valid Serializer', ->
        assert.equal 'object', typeof serializer
        assert.equal 'yaml', serializer.key

  describe 'JsonSerializer', ->
    api = slumber.API base_url, {'format': 'json'}
    serializer = api.serializer.get_serializer()

    describe '#constructor', ->
      it 'should be a valid Serializer', ->
        assert.equal 'object', typeof serializer
        assert.equal 'json', serializer.key

    describe '#loads', ->
      it 'should loads json encoded string and return a javascript object', ->
        ret = serializer.loads '{"a": 42, "b": [43, 45]}'
        assert.equal 'object', typeof ret
        assert.equal ret.a, 42
        assert.equal ret.b.length, 2

    describe '#loads#error', ->
      it 'should raise an exception', ->
        assert.throws (-> serializer.loads '{"a": 42, "b": [43, 45]'), Error

    describe '#dumps', ->
      it 'should dumps a javascript object to a json encoded string', ->
        ret = serializer.dumps {a: 42, b: [43, 45]}
        assert.equal 'string', typeof ret
        assert.equal ret, '{"a":42,"b":[43,45]}'


  describe 'UnknownSerializer', ->
    describe '#constructor', ->
      it 'should be an empty Serializer', ->
        api = slumber.API base_url, {'format': 'dontexists'}
        serializer = api.serializer.get_serializer()
        # should raise ?
        assert.equal undefined, serializer


describe 'Local Express', ->
  api = null

  before (done) ->
    freeport (err, port) ->
      app.listen port, ->
        api = slumber.API "http://localhost:#{port}/", {}, ->
          do done

  describe 'Connection', ->
    it 'should connect to express and return a string Hello World', (done) ->
      api.get (err, ret) ->
        assert.equal err, null
        assert.equal ret, 'Hello World !'
        do done

    it 'should return an array (from json) of customers', (done) ->
      api('customers').get (err, ret) ->
        assert.equal err, null
        assert.equal 'object', typeof ret
        assert.equal ret.length, 3
        do done

    it 'should return customer object (from json) with id = 1', (done) ->
      api('customers')(1).get (err, ret) ->
        assert.equal ret.user, CUSTOMERS[1].user
        assert.equal ret.age, CUSTOMERS[1].age
        assert.equal ret.gender, CUSTOMERS[1].gender
        do done

    it 'should return an array (from json) of customers for gender=male', (done) ->
      api('customers').get {'gender': 'male'}, (err, ret) ->
        assert.equal err, null
        assert.equal ret.length, 2
        do done
