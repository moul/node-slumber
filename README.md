Slumber (Node.js version)
=========================

[![Build Status](https://travis-ci.org/moul/node-slumber.png?branch=master)](https://travis-ci.org/moul/node-slumber)
[![Dependency Status](https://david-dm.org/moul/node-slumber.png?theme=shields.io)](https://david-dm.org/moul/node-slumber)
[![authors](https://sourcegraph.com/api/repos/github.com/moul/node-slumber/badges/authors.png)](https://sourcegraph.com/github.com/moul/node-slumber)
[![library users](https://sourcegraph.com/api/repos/github.com/moul/node-slumber/badges/library-users.png)](https://sourcegraph.com/github.com/moul/node-slumber)
[![Total views](https://sourcegraph.com/api/repos/github.com/moul/node-slumber/counters/views.png)](https://sourcegraph.com/github.com/moul/node-slumber)
[![Views in the last 24 hours](https://sourcegraph.com/api/repos/github.com/moul/node-slumber/counters/views-24h.png)](https://sourcegraph.com/github.com/moul/node-slumber)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/moul/node-slumber/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

![NPM Badge](https://nodei.co/npm/slumber.png?downloads=true&stars=true "NPM Badge")

Port of the Python's [slumber](https://github.com/dstufft/slumber) library in Node.js -- A library that makes consuming a RESTful API easier and more convenient

Node's Slumber is a Node.js library that provides convenient yet powerful object-oriented interface to RESTful APIs.
It acts as a wrapper around the excellent [request](https://github.com/mikeal/request) library and abstracts away the handling of URLs, serialization, and request processing.

QuickStart
----------

1. Install Node's Slumber

    ```bash
    $ npm install slumber
    ```

2. Use Node's Slumber

Usage in CoffeeScript
---------------------

```coffee
slumber = require 'slumber'

# Connect to http://slumber.in/api/v1/ with the Basic Auth user/password of demo/demo
api = slumber.API 'http://slumber.in/api/v1/', { auth: ['demo', 'demo'] }, ->

  # GET http://slumber.in/api/v1/note/
  #     Note: Any kwargs passed to get(), post(), put(), delete() will be used as url parameters
  api('note').get()

  # POST http://slumber.in/api/v1/note/
  new_post = api('note').post({'title': 'My Test Note', 'content': 'This is the content of my Test Note!'})

  # PUT http://slumber.in/api/v1/note/{id}/
  api('note')(new_post['id']).put({'content': 'I just changed the content of my Test Note!'})

  # PATCH http://slumber.in/api/v1/note/{id}/
  api('note')(new_post['id']).patch({'content': 'Wat!'})

  # GET http://slumber.in/api/v1/note/{id}/
  api('note')(new_post['id']).get()

  # DELETE http://slumber.in/api/v1/note/{id}/
  api('note')(new_post['id']).delete()

  api('resource').get {username: "example", api_key: "1639eb74e86717f410c640d2712557aac0e989c8"}

  # GET http://slumber.in/api/v1/note/?title__startswith=Bacon
  api('note').get(title__startswith="Bacon")
```

Development
-----------

[![Gitter chat](https://badges.gitter.im/moul/node-slumber.png)](https://gitter.im/moul/node-slumber)

Requirements
------------

- Node.js >= v0.10

See also
--------

* Browse [examples](https://github.com/moul/node-slumber/tree/master/examples) in CoffeeScript and Javascript

License
-------

MIT
