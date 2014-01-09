#!/usr/bin/env coffee

assert = require 'assert'
express = require 'express'
freeport = require 'freeport'

slumber = require '..'

base_url = 'http://www.example.com/'


app = express()
app.get '/', (req, res) -> res.end 'Hello World !'
app.get '/customer', (req, res) ->
  obj =
    rand: Math.random()
    aaa: 'bbb'
    ccc: 42
  res.json obj


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


describe 'JsonSerializer', ->
  api = slumber.API base_url, {}
  describe 'serializer', ->
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

    it 'should return a json object', (done) ->
      api('customer').get (err, ret) ->
        assert.equal err, null
        assert.equal 'object', typeof ret
        assert.equal 0 < ret.rand < 1, true
        assert.equal ret.aaa, 'bbb'
        assert.equal ret.ccc, 42
        do done
