//
//  ErrorModel.swift
//  EventApp
//
//  Created by ali on 8/2/21.
//  Copyright © 2021 Alexani. All rights reserved.
//

import Apollo

struct ErrorModel: Codable, Hashable {
    var message, code: String?
}

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let errors: [ErrorGraphQL]?
}

// MARK: - Error
struct ErrorGraphQL: Codable {
    let message: String
    let locations: [ErrorGraphQLLocation]
    let path: [String]
}

// MARK: - Location
struct ErrorGraphQLLocation: Codable {
    let line, column: Int
}
