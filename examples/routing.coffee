#!/usr/bin/env coffee

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'


slumber = require '..'

# Connect to http://slumber.in/api/v1/ with the Basic Auth user/password of demo/demo
api = new slumber.API 'http://slumber.in/api/v1/', { auth: ['demo', 'demo'] }, ->
  for entry in [
    #"api"
    "api.base_url"
    #"api('note')"
    "api('note').base_url"
    #"api('note')(42)"
    "api('note')(42).base_url"
    ]
    console.log '----- ', entry
    console.log eval entry
