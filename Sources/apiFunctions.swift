//
//  apiFunctions.swift
//  Perfect-NE1-Server
//
//  Created by Tim Taplin on 7/8/17.
//
//

import PerfectLib
import MySQL
import PerfectHTTP

let testHost = "127.0.0.1"
let testUser = "s3"
// PLEASE change to whatever your actual password is before running these tests
let testPassword = "password"
let testSchema = "ne1_data"

let dataMysql = MySQL()

public func userList(_ request: HTTPRequest, response: HTTPResponse) {
    
    // need to make sure something is available.
    guard dataMysql.connect(host: testHost, user: testUser, password: testPassword ) else {
        Log.info(message: "Failure connecting to data server \(testHost)")
        return
    }
    
    defer {
        dataMysql.close()  // defer ensures we close our db connection at the end of this request
    }
    
    //set database to be used, this example assumes presence of a users table and run a raw query, return failure message on a error
    guard dataMysql.selectDatabase(named: testSchema) && dataMysql.query(statement: "select * from users limit 1") else {
        Log.info(message: "Failure: \(dataMysql.errorCode()) \(dataMysql.errorMessage())")
        
        return
    }
    
    //store complete result set
    let results = dataMysql.storeResults()
    
    //setup an array to store results
    var resultArray = [[String?]]()
    
    while let row = results?.next() {
        resultArray.append(row)
        
    }
    
    //return array to http response
    response.appendBody(string: "<html><title>Mysql Test</title><body>\(resultArray.debugDescription)</body></html>")
    response.completed()
    
}

public func userLogin(_ request: HTTPRequest, response: HTTPResponse) {
    
    // need to make sure something is available.
    guard dataMysql.connect(host: testHost, user: testUser, password: testPassword ) else {
        Log.info(message: "Failure connecting to data server \(testHost)")
        return
    }
    
    var postUsername = request.param(name: "user")
    var postPass = request.param(name: "pass")
    
    defer {
        dataMysql.close()  // defer ensures we close our db connection at the end of this request
    }
    
    //set database to be used, this example assumes presence of a users table and run a raw query, return failure message on a error
    
    var sql = "select * from users where username = \'\(postUsername ?? "test2")\' and password = '\(postPass ?? "test2")'"
    guard dataMysql.selectDatabase(named: testSchema) && dataMysql.query(statement: sql) else {
        Log.info(message: "Failure: \(dataMysql.errorCode()) \(dataMysql.errorMessage())")
        
        return
    }
    
    //store complete result set
    let results = dataMysql.storeResults()
    
    if (results?.numRows())! > 0{
        
        //setup an array to store results
        var userArray = [[String?]]()
        
        while let row = results?.next() {
            userArray.append(row)
            
        }
        let userid = userArray[0][0]
        //request.session?.userid = userid!
        response.request.session?.userid = userid!
        
        // Setting the response content type explicitly to application/json
        response.setHeader(.contentType, value: "application/json")
        let returnJson = ["login": true]
        //return array to http response
        do {
            response.appendBody(string: try returnJson.jsonEncodedString())
        } catch {
            response.appendBody(string: "{\"login\":\"false\"")
        }
    } else {
        response.appendBody(string: "{\"login\":\"false\"")
    }
    response.completed()
    
    
}

public func userFavorites(_ request: HTTPRequest, response: HTTPResponse) {
    
    // need to make sure something is available.
    guard dataMysql.connect(host: testHost, user: testUser, password: testPassword ) else {
        Log.info(message: "Failure connecting to data server \(testHost)")
        return
    }
    
    var userid = request.param(name: "userid")
    
    defer {
        dataMysql.close()  // defer ensures we close our db connection at the end of this request
    }
    
    //set database to be used, this example assumes presence of a users table and run a raw query, return failure message on a error
    
    let sql = "select * from favorite_shows f left join shows s on s.show_id = f.show_id where f.user_id = \'\(userid ?? "test2")\' "
    guard dataMysql.selectDatabase(named: testSchema) && dataMysql.query(statement: sql) else {
        Log.info(message: "Failure: \(dataMysql.errorCode()) \(dataMysql.errorMessage())")
        
        return
    }
    
    //store complete result set
    let results = dataMysql.storeResults()
    
    if (results?.numRows())! > 0{
        
        //setup an array to store results
        var favoriteArray = [[String?]]()
        
        while let row = results?.next() {
            favoriteArray.append(row)
            
        }
        // Setting the response content type explicitly to application/json
        response.setHeader(.contentType, value: "application/json")
        
        //return array to http response
        do {
            response.appendBody(string: try favoriteArray.jsonEncodedString())
        } catch {
            response.appendBody(string: "{\"error\":\"no favorites\"")
        }
    } else {
        response.appendBody(string: "{\"error\":\"no favorites\"")
    }
    response.completed()
    
    
}

public func userSuggestions(_ request: HTTPRequest, response: HTTPResponse) {
    
    // need to make sure something is available.
    guard dataMysql.connect(host: testHost, user: testUser, password: testPassword ) else {
        Log.info(message: "Failure connecting to data server \(testHost)")
        return
    }
    
    var userid = request.param(name: "userid")
    
    defer {
        dataMysql.close()  // defer ensures we close our db connection at the end of this request
    }
    
    //set database to be used, this example assumes presence of a users table and run a raw query, return failure message on a error
    
    let sql = "select show_id, rating, category from shows where category in (\"action\", \"test\", \"mystery\") order by rating desc limit 5"
    guard dataMysql.selectDatabase(named: testSchema) && dataMysql.query(statement: sql) else {
        Log.info(message: "Failure: \(dataMysql.errorCode()) \(dataMysql.errorMessage())")
        
        return
    }
    
    //store complete result set
    let results = dataMysql.storeResults()
    
    if (results?.numRows())! > 0{
        
        //setup an array to store results
        var suggestionsArray = [[String?]]()
        
        while let row = results?.next() {
            suggestionsArray.append(row)
            
        }
        // Setting the response content type explicitly to application/json
        response.setHeader(.contentType, value: "application/json")
        
        //return array to http response
        do {
            response.appendBody(string: try suggestionsArray.jsonEncodedString())
        } catch {
            response.appendBody(string: "{\"error\":\"no suggestions\"")
        }
    } else {
        response.appendBody(string: "{\"error\":\"no suggestions\"")
    }
    response.completed()
    
    
}

public func userShowtime(_ request: HTTPRequest, response: HTTPResponse) {
    
    // need to make sure something is available.
    guard dataMysql.connect(host: testHost, user: testUser, password: testPassword ) else {
        Log.info(message: "Failure connecting to data server \(testHost)")
        return
    }
    
    var userid = request.param(name: "userid")
    let showid = request.param(name: "showid")
    let reactionid = request.param(name: "reactionid")
    
    defer {
        dataMysql.close()  // defer ensures we close our db connection at the end of this request
    }
    
    //set database to be used, this example assumes presence of a users table and run a raw query, return failure message on a error
    
    let sql = "select reaction_id, reaction_url, show_channel_id, rating, category, show_url from reactions r left join shows s on r.show_id = s.show_id where r.reaction_id = \(reactionid!) "
    guard dataMysql.selectDatabase(named: testSchema) && dataMysql.query(statement: sql) else {
        Log.info(message: "Failure: \(dataMysql.errorCode()) \(dataMysql.errorMessage())")
        
        return
    }
    
    //store complete result set
    let results = dataMysql.storeResults()
    
    if (results?.numRows())! > 0{
        
        //setup an array to store results
        var showRecordArray = [[String?]]()
        
        while let row = results?.next() {
            showRecordArray.append(row)
            
        }
        
        // Setting the response content type explicitly to application/json
        response.setHeader(.contentType, value: "application/json")
        
        //return array to http response
        do {
            response.appendBody(string: try showRecordArray.jsonEncodedString())
        } catch {
            response.appendBody(string: "{\"error\":\"no show available\"")
        }
    } else {
        response.appendBody(string: "{\"error\":\"no show\"")
    }
    response.completed()
    
    
}
