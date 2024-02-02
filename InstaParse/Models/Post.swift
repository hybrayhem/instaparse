//
//  Post.swift
//  InstaParse
//
//
//

import Foundation
import ParseSwift

struct Post: ParseObject {
    // ParseObject properties
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Custom properties.
    var caption: String?
    var user: User?
    var imageFile: ParseFile?
}
