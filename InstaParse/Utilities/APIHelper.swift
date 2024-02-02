//
//  APIHelper.swift
//  InstaParse
//
//  Created by hybrayhem.
//

import Foundation

struct APIHelper {
    
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
}
