//
//  ViewController.swift
//  testing
//
//  Created by Niva Ranavat on 6/21/19.
//  Copyright © 2019 Niva Ranavat. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UITextFieldDelegate,SPTSessionManagerDelegate, SPTAppRemoteDelegate,  SPTAppRemotePlayerStateDelegate {


    let SpotifyClientID = "a4f2bd3c818f418b84bb8b06de236d22"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://spotify-test35.herokuapp.com/api/token"),
            let tokenRefreshURL = URL(string: "https://spotify-test35.herokuapp.com/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = ""
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("fail", error)
    }
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed", session)
    }
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    
    
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        // Connection was successful, you can begin issuing commands
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        debugPrint("Track name: %@", playerState.track.name)
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed")
    }
    
    
    
    func createWelcomeLabel()
    {
        let welcomeLabel = UILabel(frame: CGRect(x:10, y:100, width: 400, height: 100))
        welcomeLabel.text = "Welcome to Music Synchronizer!"
        welcomeLabel.textColor = .black
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = welcomeLabel.font.withSize(36)
        welcomeLabel.numberOfLines = 2
        self.view.addSubview(welcomeLabel)
    }
    

    var user: String?
    let myLabel = UILabel(frame:CGRect(x:100,y:250,width: 200, height: 100))
    let userSearch = UITextField(frame: CGRect(x:100,y:350,width: 200, height: 50))
    let connectButton = ConnectButton(title: "CONNECT")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        createWelcomeLabel()
        
        
        myLabel.text = "Type in the userID to whom you want to match music with"
        myLabel.numberOfLines = 3
        myLabel.textColor = UIColor.gray
        myLabel.textAlignment = .center
        
        
        userSearch.backgroundColor = UIColor.lightText
        userSearch.placeholder = "UserID"
        userSearch.borderStyle = .roundedRect
        
        
        connectButton.addTarget(self, action: #selector(pressedConnect), for:.touchUpInside)
        self.view.addSubview(connectButton)
        connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        connectButton.sizeToFit()
        
        
        
        self.view.addSubview(myLabel)
        self.view.addSubview(userSearch)
        //self.view.addSubview(myButton)
        
        
        
        userSearch.delegate = self
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin editing")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("pressed return")
        user = userSearch.text
        print(user!)
        userSearch.resignFirstResponder()
        return true
    }
    
    
    @objc func pressedConnect(_ sender: UIButton)
    {
        if let user = user
            
        {
            let scope: SPTScope = [.userFollowRead]
            sessionManager.initiateSession(with: scope, options: .clientOnly)
            let auth_url = "https://accounts.spotify.com/authorize?cilent_id=a4f2bd3c818f418b84bb8b06de236d22&response_type=code&redirect_uri=spotify-ios-quick-start://spotify-login-callback&scope=user-follow-read"
            let request2 = URLRequest(url: URL(string: auth_url)!)
            let task2 = URLSession.shared.dataTask(with: request2) { data, response, error in

                guard let data = data, error == nil else { return }

                print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))

            }
            task2.resume()
            
//            print("        \n\n\n\n")
//            print("user", user)
//
//            let follow_url = String(format:"https://api.spotify.com/v1/me/following/contains?type=user&ids=%s", user)
//
//            print("url",follow_url)
//            var request = URLRequest(url: URL(string: follow_url)!)
//            request.addValue(appRemote.connectionParameters.accessToken!, forHTTPHeaderField: "Authorization")
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//
//                guard let data = data, error == nil else { return }
//
//                print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
//            }
//
//            task.resume()
//
            
            print("connection")
            
        }
    }
    
}





