# elasticsearch-lua 

[![Build Status](https://travis-ci.org/PowerDNS/elasticsearch-lua.svg)](https://travis-ci.org/PowerDNS/elasticsearch-lua) [![Coverage Status](https://coveralls.io/repos/github/PowerDNS/elasticsearch-lua/badge.svg)](https://coveralls.io/github/PowerDNS/elasticsearch-lua)

[![License](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](LICENSE)

[![LuaRocks](https://img.shields.io/badge/LuaRocks-2.4.1-blue.svg)](https://luarocks.org/modules/neilcook/elasticsearch-lua) [![Lua](https://img.shields.io/badge/Lua-5.1-blue.svg)](https://img.shields.io/badge/Lua-5.1-blue.svg)[![LuaJIT](https://img.shields.io/badge/LuaJIT-2.0-blue.svg)](https://img.shields.io/badge/LuaJIT-2.0-blue.svg)

A low level client for Elasticsearch written in Lua. This is a fork of
the original repo by Dhaval Kapil, which he no longer maintains. This
repo does not try to be all things to all people. It specifically
supports Elasticsearch 6.x (at the moment) and Lua 5.1/LuaJIT 2.0.

In accordance with the official low level clients, the client accepts associative arrays in the form of lua table as parameters.

## Features:

1. One-to-one mapping with REST API and other language clients.
2. Proper load balancing across all nodes.
3. Pluggable and multiple connection, selection strategies and connection pool.
4. Console logging facility.
5. Almost every parameter is configurable.

## Elasticsearch Version Matrix

| Elasticsearch Version | elasticsearch-lua Branch |
| --------------------- | ------------------------ |
| >= 6.0, < 7.0         |  master                  |

## Lua Version Requirements

`elasticsearch-lua` works for lua = 5.1 version and luajit = 2.0.

## Setup

It can be installed using [luarocks](https://luarocks.org)

```
  [sudo] luarocks install elasticsearch-lua
```

## Documentation

The complete documetation is [here](http://elasticsearch-lua.readthedocs.io/).

### Create elasticsearch client instance:

```lua
  local elasticsearch = require "elasticsearch"

  local client = elasticsearch.client{
    hosts = {
      { -- Ignoring any of the following hosts parameters is allowed.
        -- The default shall be set
        protocol = "http",
        host = "localhost",
        port = 9200,
        username = "elastic",
        password = "changeme",
        verify = "peer",
        cafile = ""
      }
    },
    -- Optional parameters
    params = {
      pingTimeout = 2
    }
  }
```

The `verify` and `cafile` params are only applicable if the protocol
is `https`.

```lua
  -- Will connect to default host/port
  local client = elasticsearch.client()
```

Full list of `params`:

1. `pingTimeout` : The timeout of a connection for ping and sniff request. Default is 1.
2. `selector` : The type of selection strategy to be used. Default is `RoundRobinSelector`.
3. `connectionPool` : The type of connection pool to be used. Default is `StaticConnectionPool`.
4. `connectionPoolSettings` : The connection pool settings,
5. `maxRetryCount` : The maximum times to retry if a particular connection fails.
6. `logLevel` : The level of logging to be done. Default is `warning`.

### Standard call

```lua
local param1, param2 = client:<func>()
```

`param1`: Stores the data returned or `nil` on error

`param2`: Stores the HTTP status code on success or the error message on failure

### Getting info of elasticsearch server

```lua
local data, err = client:info()
```

### Type mapping deprecation

Elasticsearch is in the process of deprecating and removing type
mappings. To that end, if the type parameter is supplied, it will be
replaced with the value "_doc", which ensures forwards compatibility
at the expense of backward compatibility with ES 5.x or below.

### Index a document

Everything is represented as a lua table.

```lua
local data, err = client:index{
  index = "my_index",
  type = "my_type",
  id = "my_doc",
  body = {
    my_key = "my_param"
  }
}
```

### Get a document

```lua
data, err = client:get{
  index = "my_index",
  type = "my_type",
  id = "my_doc"
}
```

### Delete a document

```lua
data, err = client:delete{
  index = "my_index",
  type = "my_type",
  id = "my_doc"
}
```
### Searching a document

You can search a document using either query string:

```lua
data, err = client:search{
  index = "my_index",
  type = "my_type",
  q = "my_key:my_param"
}
```

Or either a request body:

```lua
data, err = client:search{
  index = "my_index",
  type = "my_type",
  body = {
    query = {
      match = {
        my_key = "my_param"
      }
    }
  }
}
```

### Update a document

```lua
data, err = client:update{
  index = "my_index",
  type = "my_type",
  id = "my_doc",
  body = {
    doc = {
      my_key = "new_param"
    }
  }
}
```

## Contribution

Feel free to [file issues](https://github.com/PowerDNS/elasticsearch-lua/issues) and submit [pull requests](https://github.com/PowerDNS/elasticsearch-lua/pulls) – contributions are welcome. Please try to follow the code style used in the repository.

## License

elasticsearch-lua is licensed under the [MIT license](https://dhaval.mit-license.org/2015/license.txt).
