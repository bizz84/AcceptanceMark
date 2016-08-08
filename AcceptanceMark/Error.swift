//
//  Error.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 08/08/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

enum Error: Swift.Error {
    case TestNotImplemented
    case ParseInputError(message : String)
    case ParseOutputError(message: String)
}
