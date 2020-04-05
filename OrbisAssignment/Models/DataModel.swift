//
//  DataModel.swift
//  OrbisAssignment
//
//  Created by Suraj on 4/5/20.
//  Copyright © 2020 Mobikasa. All rights reserved.
//

import Foundation

// MARK: - Task
struct Task: Codable {
    let id, name: String
    let order: [String]
    let requests: [Request]
}

// MARK: - Request
struct Request: Codable {
    let id, name: String
    let url: String
    let description: String
    let data: [Datum]
    let dataMode: String
    let method: String
    let collectionId, headers: String

}

// MARK: - Datum
struct Datum: Codable {
    let key, value, type,description: String
    let enabled: Bool
}
