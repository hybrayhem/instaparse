//
//  APIHelper.swift
//  InstaParse
//
//  Created by hybrayhem.
//

import Foundation
import UIKit
import ParseSwift

struct APIManager {
    // MARK: - API Config
    func getAPIProperties() -> (applicationId: String, clientKey: String, serverURL: String) {
        guard let filePath = Bundle.main.path(forResource: "ParseAPI", ofType: "plist") else {
            preconditionFailure("Couldn't find file.") // Crash
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        
        let applicationId = getValueSafe(plist, key: "applicationId")
        let clientKey = getValueSafe(plist, key: "clientKey")
        let serverURL = getValueSafe(plist, key: "serverURL")
        
        return (applicationId, clientKey, serverURL)
    }
    
    func getValueSafe(_ plist: NSDictionary?, key: String) -> String {
        guard let value = plist?.object(forKey: key) as? String else {
            preconditionFailure("Couldn't find '\(key)' in plist.") // Crash
        }
        return value
    }
    
    // MARK: - Auth
    func signUpUser(username: String, email: String, password: String, completion: @escaping (Result<User, ParseError>) -> Void) {
        var newUser = User()
        newUser.username = username
        newUser.email = email
        newUser.password = password
        
        newUser.signup { result in
            completion(result)
        }
    }
    
    func logInUser(username: String, password: String, completion: @escaping (Result<User, ParseError>) -> Void) {
        User.login(username: username, password: password) { result in
            completion(result)
        }
    }
    
    func logOutUser(completion: @escaping (Result<Void, ParseError>) -> Void) {
        // Removes the session from Keychain, and log out of linked services
        User.logout { result in
            completion(result)
        }
    }
    
    // MARK: - Post Operations
    // Create
    func createPost(withImage image: UIImage?, caption: String?, completion: @escaping (Result<Post, ParseError>) -> Void) {
        // get user
        guard let currentUser = User.current else {
            return completion(.failure(otherParseError("No current user.")))
        }
        
        // create compressed jpeg
        guard let imageData = imageToData(image) else {
            return completion(.failure(otherParseError("Invalid post image.")))
        }
        
        // prepare post
        let imageFile = ParseFile(name: "image.jpg", data: imageData)
        var post = Post()
        post.imageFile = imageFile
        post.caption = caption
        post.user = currentUser
        
        // save async
        post.save { postResult in
            updateLastPostedDate(user: currentUser) { userResult in
                switch userResult {
                case .success(_):
                    completion(postResult)
                case .failure(let userError):
                    completion(.failure(userError))
                }
            }
        }
    }
    
    private func otherParseError(_ message: String) -> ParseError {
            return ParseError(otherCode: 0, message: message)
    }
    
    private func imageToData(_ image: UIImage?) -> Data? {
        guard let image = image,
              let imageData = image.jpegData(compressionQuality: 0.1)
        else { return nil }
        
        return imageData
    }

    private func updateLastPostedDate(user: User, completion: @escaping (Result<User, ParseError>) -> Void) {
        var currentUser = user
        currentUser.lastPostedDate = Date()
        
        currentUser.save { result in
            completion(result)
        }
    }
    
    func updateLastPostedDate(completion: @escaping (Result<User, ParseError>) -> Void) {
        guard let currentUser = User.current else {
            return completion(.failure(otherParseError("No current user.")))
        }
        updateLastPostedDate(user: currentUser, completion: completion)
    }
    
    // Fetch
    func fetchPosts(completion: @escaping (Result<[Post], ParseError>) -> Void) {
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: (-1), to: Date())!
        
        // define query
        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
            .where("createdAt" >= yesterdayDate)
            .limit(10)
        
        // fetch query async
        query.find { result in
            completion(result)
        }
    }
}
