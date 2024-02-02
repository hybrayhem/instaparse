//
//  APIHelper.swift
//  InstaParse
//
//  Created by hybrayhem.
//

import Foundation
import ParseSwift

struct APIManager {
    
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
}
