//
//  User.swift
//  InstaParse
//
//
//

import Foundation
import ParseSwift

struct User: ParseUser {
    // ParseObject properties
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // ParseUser properties
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?

    // Custom properties
    // var customKey: String?
}
