//
//  AppDelegate.swift
//  testing
//
//  Created by Niva Ranavat on 6/21/19.
//  Copyright © 2019 Niva Ranavat. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var rootViewController = ViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = window{
            
            window.backgroundColor=UIColor.white
            
            window.makeKeyAndVisible()
            
            window.rootViewController = ViewController()
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        rootViewController.sessionManager.application(app, open: url, options: options)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if rootViewController.appRemote.isConnected {
            rootViewController.appRemote.disconnect()
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let _ = rootViewController.appRemote.connectionParameters.accessToken {
            rootViewController.appRemote.connect()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}



//import UIKit
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
//    var window: UIWindow?
//    lazy var rootViewController = ViewController()
//
//
//    let SpotifyClientID = "a4f2bd3c818f418b84bb8b06de236d22"
//    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
//
//    lazy var configuration = SPTConfiguration(
//        clientID: SpotifyClientID,
//        redirectURL: SpotifyRedirectURL
//    )
//
//    lazy var sessionManager: SPTSessionManager = {
//        if let tokenSwapURL = URL(string: "https://spotify-test35.herokuapp.com/api/token"),
//            let tokenRefreshURL = URL(string: "https://spotify-test35.herokuapp.com/api/refresh_token") {
//            self.configuration.tokenSwapURL = tokenSwapURL
//            self.configuration.tokenRefreshURL = tokenRefreshURL
//            self.configuration.playURI = ""
//        }
//        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
//        return manager
//    }()
//
//    lazy var appRemote: SPTAppRemote = {
//        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
//        appRemote.delegate = self
//        return appRemote
//    }()
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        let requestedScopes: SPTScope = [.appRemoteControl]
//        self.sessionManager.initiateSession(with: requestedScopes, options: .default)
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = rootViewController
//        window?.makeKeyAndVisible()
//
//        return true
//    }
//
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        self.sessionManager.application(app, open: url, options: options)
//
//        return true
//    }
//
//    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
//        self.appRemote.connectionParameters.accessToken = session.accessToken
//        print("what I am looking for", self.appRemote.authorizeAndPlayURI(""))
//        self.appRemote.connect()
//    }
//
//    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
//        print(error)
//    }
//
//    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
//        print(session)
//    }
//
//    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
//        print("connected")
//
//        self.appRemote.playerAPI?.delegate = self
//        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
//            if let error = error {
//                debugPrint(error.localizedDescription)
//            }
//        })
////        print(self.appRemote.userAPI?.description)
////        self.appRemote.userAPI?.fetchLibraryState(forURI: "spotify:track:13WO20hoD72L0J13WTQWlT" , callback: {(result, error) in
////                if let error = error {
////                    print(error.localizedDescription)
////                }
////            })
//
//
//        //Want to play a new track?
//        var name : String = rootViewController.song_name.text!
//        print(name)
//        self.appRemote.playerAPI?.play(name, callback: { (result, error) in
//                if let error = error {
//                        print(error.localizedDescription)
//                        }
//        })
////        self.appRemote.playerAPI?.play("spotify:track:13WO20hoD72L0J13WTQWlT", callback: { (result, error) in
////            if let error = error {
////                 print(error.localizedDescription)
////            }
////        })
//
//    }
//    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
//        print("disconnected")
//    }
//
//    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
//        print("failed")
//    }
//
//    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
//        print("player state changed")
//        print("isPaused", playerState.isPaused)
//        print("track.uri", playerState.track.uri)
//        print("track.name", playerState.track.name)
//        print("track.imageIdentifier", playerState.track.imageIdentifier)
//        print("track.artist.name", playerState.track.artist.name)
//        print("track.album.name", playerState.track.album.name)
//        print("track.isSaved", playerState.track.isSaved)
//        print("playbackSpeed", playerState.playbackSpeed)
//        print("playbackOptions.isShuffling", playerState.playbackOptions.isShuffling)
//        print("playbackOptions.repeatMode", playerState.playbackOptions.repeatMode.hashValue)
//        print("playbackPosition", playerState.playbackPosition)
//    }
//
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//        if self.appRemote.isConnected {
//            self.appRemote.disconnect()
//        }
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        if let _ = self.appRemote.connectionParameters.accessToken {
//            self.appRemote.connect()
//        }
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }
//}
//


//import UIKit
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//    lazy var rootViewController = ViewController()
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = rootViewController
//        window?.makeKeyAndVisible()
//        return true
//    }
//
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        rootViewController.sessionManager.application(app, open: url, options: options)
//        return true
//    }
//
//    func applicationWillResignActive(_ application: UIApplication) {
//        if (rootViewController.appRemote.isConnected) {
//            rootViewController.appRemote.disconnect()
//        }
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        if let _ = rootViewController.appRemote.connectionParameters.accessToken {
//            rootViewController.appRemote.connect()
//        }
//    }
//}
