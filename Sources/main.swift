//
//  main.swift
//  Perfect JSON API Example
//
//  Created by Jonathan Guthrie on 2016-09-26.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectSession
import PerfectSessionMySQL

// Create HTTP server.
let server = HTTPServer()


SessionConfig.name = "NE1SessionConfig"
SessionConfig.idle = 60

// Optional
SessionConfig.cookieDomain = "ne1"

//MySQLSessionConnector.host = "localhost"
//MySQLSessionConnector.port = 3306
//MySQLSessionConnector.username = "s3"
//MySQLSessionConnector.password = "password"
//MySQLSessionConnector.database = "ne1_data"
//MySQLSessionConnector.table = "sessions"

let sessionDriver = SessionMemoryDriver()

server.setRequestFilters([sessionDriver.requestFilter])
server.setResponseFilters([sessionDriver.responseFilter])
//server.setRequestFilters([sessionDriver.requestFilter])
//server.setResponseFilters([sessionDriver.responseFilter])

// Create the container variable for routes to be added to.
var routes = Routes()
server.documentRoot = "./webroot"
// Register your own routes and handlers
// This is an example "Hello, world!" HTML route
routes.add(method: .get, uri: "/", handler: {
	request, response in
	// Setting the response content type explicitly to text/html
	response.setHeader(.contentType, value: "text/html")
	// Adding some HTML to the response body object
	response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
	// Signalling that the request is completed
	response.completed()
	}
)

// Adding a route to handle the GET people list URL
routes.add(method: .get, uri: "/api/v1/people", handler: {
	request, response in

	let people = People()

	// Setting the response content type explicitly to application/json
	response.setHeader(.contentType, value: "application/json")
	// Setting the body response to the JSON list generated
	response.appendBody(string: people.list())
	// Signalling that the request is completed
	response.completed()
	}
)

// Adding a route to handle the POST people add URL, with post body params
routes.add(method: .post, uri: "/api/v1/people", handler: {
	request, response in

	let people = People()

	// Setting the response content type explicitly to application/json
	response.setHeader(.contentType, value: "application/json")
	// Adding a new "person", passing the complete HTTPRequest object to the function.
	response.appendBody(string: people.add(request))
	// Signalling that the request is completed
	response.completed()
	}
)

// Adding a route to handle the POST people add via JSON
routes.add(method: .post, uri: "/api/v1/people/json", handler: {
	request, response in

	let people = People()

	// Setting the response content type explicitly to application/json
	response.setHeader(.contentType, value: "application/json")
	// Adding a new "person", passing the just the request's post body as a raw string to the function.
	response.appendBody(string: people.add(request.postBodyString!))
	// Signalling that the request is completed
	response.completed()
	}
)
//This route will be used to fetch data from the mysql database
routes.add(method: .get, uri: "/api/v1/users", handler: userList)

routes.add(method: .post, uri: "/api/v1/user/login", handler: userLogin)
routes.add(method: .post, uri: "/api/v1/user/favorites", handler: userFavorites)
routes.add(method: .post, uri: "/api/v1/user/suggestions", handler: userSuggestions)
routes.add(method: .post, uri: "/api/v1/user/showtime", handler: userShowtime)


// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181

do {
	// Launch the HTTP server.
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}
