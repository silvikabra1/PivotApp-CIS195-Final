//
//  ClubViewController.swift
//  Pivot
//
//  Created by Silvi Kabra on 4/13/20.
//  Copyright © 2020 Silvi Kabra. All rights reserved.
//

import UIKit

struct GroupMeGroupList: Decodable {
    let response: [GroupMeGroup]
}
struct GroupMeGroup: Decodable {
    let group_id: String
    let name: String
    let updated_at: TimeInterval
    let messages: GroupMeMessageOverview
}

struct GroupMeMessageOverview: Decodable {
    let last_message_id: String
    let preview: GroupMeMessage
}
struct GroupMeMessage: Decodable {
    let nickname: String
    let text: String
}

class ClubViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var clubName: String?
    var clubImage: UIImage?
    var favorited: Bool?
    var linkedApps: [String]?
    var tokens: [String]?
    var groupName: String?
    
    var groupMeGroups = [GroupMeGroup]()
    
    var tableGroupMeGroup: GroupMeGroup?

    var tableGroups = [Any]()
    
    @IBOutlet var clubNameLabel: UILabel!
    //@IBOutlet var clubFavoritedImageView: UIImageView!
    @IBOutlet var clubImageView: UIImageView!
   // @IBOutlet var favoriteButton: UIButton!
    
   /* @IBAction func toggleFavorites (_ sender: UIButton) {
        if sender.titleLabel!.text! == "Add to favorites" {
            sender.setTitle("Remove from favorites", for: .normal)
        } else {
            sender.setTitle("Add to favorites", for: .normal)
        }
        favorited!.toggle()
    }*/
    
    @IBOutlet var tableView: UITableView!
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print (tableGroups.count)
        return tableGroups.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "linkedAppCell")
        if let linkedAppName = cell?.viewWithTag(1) as? UILabel {
            linkedAppName.text = "GroupMe"
        }
        
        if let nameLabel = cell?.viewWithTag(2) as? UILabel {
            print(tableGroupMeGroup!.messages.preview.nickname)
            nameLabel.text = "Last Message"

        }
        
        if let messageLabel = cell?.viewWithTag(3) as? UILabel {
            messageLabel.text = "\(tableGroupMeGroup!.messages.preview.nickname): \(tableGroupMeGroup!.messages.preview.text)"
        }
        
        if let dateLabel = cell?.viewWithTag(4) as? UILabel {
            let dateFormatter = DateFormatter()
            let date = Date(timeIntervalSince1970: tableGroupMeGroup!.updated_at)
            dateFormatter.dateFormat = "hh:mm MM/dd/yyyy"
            print(date)
            print(dateFormatter.string(from: date))
            dateLabel.text = dateFormatter.string(from: date)
        }
        
        return cell!
    }
    
    
    func fetchGroups() {
        if let tokens = tokens {
            let urlString = "https://api.groupme.com/v3/groups?omit=memberships&token=\(tokens[0])"
            guard let url = URL(string: urlString) else { return }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                print("ok good")
                if let decodedGroups = try? JSONDecoder().decode(GroupMeGroupList.self, from: data) {
                    print("ok good")
                    self.groupMeGroups = decodedGroups.response
                    DispatchQueue.main.async {
                        for group in self.groupMeGroups {
                            if (self.groupName == group.name) {
                                self.tableGroupMeGroup = group
                                self.tableGroups.append(self.tableGroupMeGroup)
                                print (self.tableGroups.count)

                            }
                        }
                        print("do it")
                        self.tableView.reloadData()
                       
                    }
                    
                } else {
                    print("try again")
                    }
            }
            }
            task.resume()
        } else {
            let alertController = UIAlertController(title: "No groups have been linked", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true)
        }
        

        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Dashboard"
        self.clubNameLabel.text = clubName!
        if let favorited = favorited {
            if favorited == true {
               // clubFavoritedImageView.image = UIImage(named: "star-filled")
              //  self.favoriteButton.setTitle("Remove from favorite", for: .normal)
            } else {
              //  clubFavoritedImageView.image = UIImage(named: "star-hollow")
             //   self.favoriteButton.setTitle("Add to favorites", for: .normal)
            }
        }
        self.clubImageView.image = clubImage
        self.clubImageView.layer.cornerRadius = self.clubImageView.frame.size.width/2
        self.clubImageView.contentMode = .scaleAspectFill
        self.clubImageView.clipsToBounds = true
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.layer.borderColor = UIColor.systemGray.cgColor
        fetchGroups()
    }
    


}
