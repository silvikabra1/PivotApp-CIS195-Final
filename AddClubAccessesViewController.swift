//
//  AddClubAccessesViewController.swift
//  Pivot
//
//  Created by Silvi Kabra on 4/13/20.
//  Copyright © 2020 Silvi Kabra. All rights reserved.
//

import UIKit
import AuthenticationServices

protocol AddClubDelegate: class {
    func didCreate(_ club: Club)
}

class AddClubAccessesViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    weak var delegate: AddClubDelegate?
    
    @IBOutlet var linkAppsLabel: UILabel!
    @IBOutlet var groupMeButton: UIButton!
    
    var name: String?
    var position: String?
    var dateStarted: Date?
    var clubIcon: UIImage?
    var group: String?
    
    var webAuthSession: ASWebAuthenticationSession?
    var token: String?
    
    @IBAction func didClickGroupme(_ sender: UIButton) {
        print("good")

        getToken(context: self, url: "https://oauth.groupme.com/oauth/login_dialog?client_id=Ju7pzHxuyu1eTyxKtnKgMwExNbReccZlb30NQbFn6gxtu4vc")
    }
    
    @IBAction func didSelectSave (_ sender: UIButton) {
        let club = createNewClub()
        if club != nil {
            dump(club!)
            self.delegate?.didCreate(club!)
        }
    }
    
    func createNewClubAfterLinkingApp() {
        var club = createNewClub()
        club?.linkedApps = ["GroupMe"]
        club?.tokens = [token!]
        club?.groupMeGroup = group!
        if club != nil {
            dump(club!)
            self.delegate?.didCreate(club!)
        }
    }
    
    func createNewClub() -> Club? {
        if name == nil {
            return nil
        }
        let tempClub = Club(clubName: name!, clubPicture: clubIcon ?? nil, position: position ?? nil, dateJoined: dateStarted ?? nil, linkedApps: nil, tokens: nil, favorited: false, groupMeGroup: nil)
        return tempClub
    }
    
    func promptForNameOfGroup() {
        let alertController = UIAlertController(title: "Enter exact name of GroupMe conversation to link", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        let submit = UIAlertAction(title: "Enter", style: .default) { [unowned alertController] _ in
            let answer = alertController.textFields![0]
            self.group = answer.text!
            self.createNewClubAfterLinkingApp()
        }
        alertController.addAction(submit)
        present(alertController, animated: true)
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }

    
    func getToken(context: ASWebAuthenticationPresentationContextProviding, url: String) {
        let authURL = URL(string: url)
        let callbackUrlScheme = "https://com.pivotapp"
        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            
            guard error == nil, let successURL = callBack else {
                return
            }
            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "access_token"}).first
            print(oauthToken ?? nil!)
            self.token = oauthToken?.description
            self.token = String(((self.token?.dropFirst(13))!))
            print(self.token!)
            self.promptForNameOfGroup()

        })
        self.webAuthSession?.presentationContextProvider = context
        self.webAuthSession?.start()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
