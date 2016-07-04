#!/usr/bin/env coffee

fs = require 'fs'
slumber = require '..'

api = slumber.API 'http://httpbin.org/', {}, ->
  data =
    headers:
      "content-type": "application/x-www-form-urlencoded"
    string: 'hello world'
    buffer: new Buffer [1,2,3]
    number: 42
    attachments: [
      fs.createReadStream(__dirname + "/post-file.coffee")
      fs.createReadStream(__dirname + "/post-file.js")
    ]
    custom_file:
      value: fs.createReadStream("/dev/urandom")
      options:
        filename: "topsecret.jpg"
        contentType: "image/jpg"
  api('post').postForm data, (ret) ->
    console.log ret
