//
//  AppDelegate.swift
//  InstaParse
//
//
//

import UIKit
import ParseSwift

//: Create your own value typed `ParseObject`.
struct GameScore: ParseObject {
    //: These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    //: Your own properties.
    var points: Int?

    /*:
     Optional - implement your own version of merge
     for faster decoding after updating your `ParseObject`.
     */
    func merge(with object: Self) throws -> Self {
        var updated = try mergeParse(with: object)
        if updated.shouldRestoreKey(\.points,
                                     original: object) {
            updated.points = object.points
        }
        return updated
    }
}

//: It's recommended to place custom initializers in an extension
//: to preserve the memberwise initializer.
extension GameScore {

    init(points: Int) {
        self.points = points
    }

    init(objectId: String?) {
        self.objectId = objectId
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let apiConfig = APIHelper().getAPIProperties()
        ParseSwift.initialize(
            applicationId: apiConfig.applicationId,
            clientKey: apiConfig.clientKey,
            serverURL: URL(string: apiConfig.serverURL)!
        )
        
        let score = GameScore(points: 10)
        let score2 = GameScore(points: 3)
        /*: Save asynchronously (preferred way) - Performs work on background
            queue and returns to specified callbackQueue.
            If no callbackQueue is specified it returns to main queue.
        */
        score.save { result in
            switch result {
            case .success(let savedScore):
                assert(savedScore.objectId != nil)
                assert(savedScore.createdAt != nil)
                assert(savedScore.updatedAt != nil)
                assert(savedScore.points == 10)

                /*:
                 To modify, you need to make it a var as the value type
                 was initialized as immutable. Using `mergeable`
                 allows you to only send the updated keys to the
                 parse server as opposed to the whole object. Make sure
                 to call `mergeable` before you begin
                 your first mutation of your `ParseObject`.
                */
                var changedScore = savedScore.mergeable
                changedScore.points = 200
                changedScore.save { result in
                    switch result {
                    case .success(let savedChangedScore):
                        assert(savedChangedScore.points == 200)
                        assert(savedScore.objectId == savedChangedScore.objectId)

                    case .failure(let error):
                        assertionFailure("Error saving: \(error)")
                    }
                }
            case .failure(let error):
                assertionFailure("Error saving: \(error)")
            }
        }

        // TODO: Pt 1: - Instantiate and save a test parse object to your server
        // https://github.com/parse-community/Parse-Swift/blob/3d4bb13acd7496a49b259e541928ad493219d363/ParseSwift.playground/Pages/1%20-%20Your%20first%20Object.xcplaygroundpage/Contents.swift#L121


        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// TODO: Pt 1 - Create Test Parse Object
// https://github.com/parse-community/Parse-Swift/blob/3d4bb13acd7496a49b259e541928ad493219d363/ParseSwift.playground/Pages/1%20-%20Your%20first%20Object.xcplaygroundpage/Contents.swift#L33
