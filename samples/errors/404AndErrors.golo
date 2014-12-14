module notfoundAndErrors

import kiss
import kiss.request
import kiss.response
import kiss.httpExchange

function main = |args| {

  let server = HttpServer("localhost", 8080, |app| {

    # respond with "Hello World!" on the homepage
    app: method("GET", |route| -> route: equals("/"), |response, request| ->
      response : html("<h1>Hello World!!!</h1>")
    )

    # generate html report error
    app: method("GET", |route| -> route: equals("/generror"), |response, request| {
      let division = 5 / 0
      println("pas bon")
      #response: html("ouch")
    })

  })

  #server: whenError(|response, request, error| {
  #  response : html("<h1>Error!!!</h1><h2>" + error: getMessage() + "</h2>")
  #})

  #server: when404(|response, request| {
  #  response : html("<h1>404!!!</h1>")
  #})

  server: start(">>> http://localhost:8080/")

}
