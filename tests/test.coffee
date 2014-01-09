#!/usr/bin/env coffee

assert = require 'assert'
express = require 'express'
freeport = require 'freeport'

slumber = require '..'

base_url = 'http://www.example.com/'


app = express()
app.get '/', (req, res) -> res.end 'Hello World !'


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
