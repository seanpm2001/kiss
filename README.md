kiss
====

Fast, unopinionated, minimalist web framework for Golo 


##Install

    git clone  https://github.com/k33g/kiss.git project_name

##Run it

    golo golo --files imports/*.golo main.golo

    # or;
    golo golo --files imports/*.golo sample01.golo

    # or:
    golo golo --files imports/*.golo sample02.golo

##Hello world example

```coffeescript
module hello.world

import kiss

function main = |args| {

  let server = HttpServer("localhost", 8080, |app| {

    app: all(|response, request| ->
      response
        : contentType("text/html")
        : content("<h1>Hello World!</h1>")
    )

  })

  server: start(">>> http://localhost:8080/")
}
```

##Basic routing

```coffeescript
module basic.routing

import kiss

function main = |args| {

  let server = HttpServer("localhost", 8080, |app| {

    # respond with "Hello World!" on the homepage
    app: method("GET", |route|-> route: equals("/"), |response, request| ->
      response : html("<h1>Hello World!</h1>")
    )

    # accept POST request on the homepage
    app: method("POST", |route|-> route: equals("/"), |response, request| ->
      response: html("<h1>Got a POST request</h1>")
    )

    # accept GET request at /users/some/thing
    app: method("GET", |route|-> route: startsWith("/users/"), |response, request| ->
      response : json(DynamicObject()
        : message("Got a GET request at /users/some/thing")
        : uriParts(request: uri(): parts()) # return ["users", "some", "thing"]
      )
    )

    # accept PUT request at /users
    app: method("PUT", |route|-> route: equals("/users"), |response, request| ->
      response: html("Got a PUT request at /users")
    )

    # accept DELETE request at /users
    app: method("DELETE", |route|-> route: equals("/users"), |response, request| ->
      response: html("Got a DELETE request at /users")
    )

  })

  server: start(">>> http://localhost:8080/")
}
```

##Routing with route template

```coffeescript
module templates.routing

import kiss

function main = |args| {

  let server = HttpServer("localhost", 8080, |app| {

    # accept GET request at /users/some/thing
    app: route("GET", "/users/{some}/{thing}", |response, request| ->
      response : json(DynamicObject()
        : message("Got a GET request at /users/some/thing")
        : some(request: params("some"))
        : thing(request: params("thing"))
      )
    )

  })

  server: start(">>> http://localhost:8080/")
}
```

##Static assets

```coffeescript
module main

import kiss

function main = |args| {

  let server = HttpServer("localhost", 8080, |app| {

    app: static("/public", "index.html")

  })

  server: start(">>> http://localhost:8080/")

}
```

##CORS support

```coffeescript
module main

import kiss

function main = |args| {

  let server = HttpServer("localhost", 8080, |app| {

    # CORS support
    app: method("GET", |route| -> route: equals("/cors/humans"), |res, req| {
      res: allowCORS("*", "*", "*")
      res: json(DynamicObject(): message("all humans"))
    })

  })

  server: start(">>> http://localhost:8080/")

}
```

##Cookies support

```coffeescript
module cookies

import kiss

function main = |args| {

  let server = HttpServer("localhost", 8080, |app| {

    # static assets location
    app: static("/public", "index.html")

    # cookies management

    app: method("GET", |route| -> route: equals("/setcookie"), |res, req| {
      let myUuid = uuid()
      res: cookie("bob", myUuid)
      res: json(DynamicObject(): newCookie(myUuid))
    })

    app: method("GET", |route| -> route: equals("/getcookie"), |res, req| {
      res: json(DynamicObject(): cookie(req: cookie("bob")))
    })

    app: method("GET", |route| -> route: equals("/deletecookie"), |res, req| {
      res: removeCookie("bob")
      res: json(DynamicObject(): deletedCookie(req: cookie("bob")))
    })

    app: method("GET", |route| -> route: equals("/getallcookies"), |res, req| {
      res: json(DynamicObject(): cookies(req: cookies()))
    })

  })

  server: start(">>> http://localhost:8080/")

}
```

##Handle 404

```coffeescript
module notfoundAndErrors

import kiss

function main = |args| {

  let server = HttpServer("localhost", 8080, |app| {

    # respond with "Hello World!" on the homepage
    app: method("GET", |route| -> route: equals("/"), |response, request| ->
      response : html("<h1>Hello World!</h1>")
    )

  })

  server: when404(|response, request| {
    response : html("<h1>404!!!</h1>")
  })

  server: start(">>> http://localhost:8080/")
}
```

##Handle Errors

```coffeescript
module notfoundAndErrors

import kiss

function main = |args| {

  let server = HttpServer("localhost", 8080, |app| {

    # respond with "Hello World!" on the homepage
    app: method("GET", |route| -> route: equals("/"), |response, request| ->
      response : html("<h1>Hello World!</h1>")
    )

    # generate html report error
    app: method("GET", |route| -> route: equals("/generror"), |response, request| {
      let division = 5 / 0
      response: content("ouch")
    })

  })

  server: whenError(|response, request, error| {
    response : html("<h1>Error!!!</h1><h2>" + error: getMessage() + "</h2>")
  })

  server: start(">>> http://localhost:8080/")
}
```

**Remark**: if you don't use `server: whenError(...)`, Kiss displays error message and stacktrace in the browser.


##Redirection

```coffeescript
# redirect to /home
app: method("GET", |route| -> route: equals("/"), |response, request| ->
  response: redirect("/home", 301)
  # or response: redirect("/home"), default status code is 302
)

# home page
app: method("GET", |route| -> route: equals("/home"), |response, request| {
  response: html("<h1>this is the Home</h1>")
})
```

#TODO:

- set cookie with max-age
- https
- documentation
- SSE
