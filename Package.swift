//
//  Package.swift
//  Based on :
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

import PackageDescription

// Note that the following Swift Package Manager dependancy inclusion will also import other required modules.
let package = Package(
    name: "Perfect-NE1-Server",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Crypto.git", majorVersion: 1),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Session-MySQL.git", majorVersion: 1),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-LocalAuthentication-MySQL.git", majorVersion: 1),
	]
)
