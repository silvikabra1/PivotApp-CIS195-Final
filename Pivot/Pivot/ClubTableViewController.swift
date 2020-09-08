//
//  ClubTableViewController.swift
//  Pivot
//
//  Created by Silvi Kabra on 4/13/20.
//  Copyright © 2020 Silvi Kabra. All rights reserved.
//

import UIKit

class ClubTableViewController: UITableViewController, AddClubDelegate {
    
    func didCreate(_ club: Club) {
        dismiss(animated: true, completion: nil)
        if (club.favorited == true) {
            favoritedClubs.append(club)
        }
        clubs.append(club)
        self.tableView.reloadData()

    }
    
    var clubs = [Club]()
    var favoritedClubs = [Club]()
    
    let raas = Club(clubName: "Penn Raas", clubPicture: nil, position: "Manager", dateJoined: nil, linkedApps: nil, favorited: false)
    

    @IBAction func didSelectAdd(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewClubSegue", sender: nil)
    }
    
    @IBAction func didSelectEdit(_ sender: UIBarButtonItem) {
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        clubs.append(raas)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "getClubDetailsSegue", sender: clubs[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getClubDetailsSegue" {
            if let club = sender as? Club {
                    if let clubVC = segue.destination as? ClubViewController {
                        print(club.clubName)
                        clubVC.clubName = club.clubName
                        clubVC.favorited = club.favorited
                        clubVC.linkedApps = club.linkedApps
                        clubVC.groupName = club.groupMeGroup
                        clubVC.tokens = club.tokens
                        clubVC.clubImage = club.clubPicture
                    }
            }
        }
        if segue.identifier == "addNewClubSegue" {
             if let addClubVC = segue.destination as? AddClubViewController {
                    addClubVC.delegate = self
                
            }
        }
        
        
    }
    
    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "clubCell")
        
        if let clubIconView = cell?.viewWithTag(1) as? UIImageView {
            clubIconView.layer.cornerRadius = clubIconView.frame.size.width/2
            clubIconView.contentMode = .scaleAspectFill
            clubIconView.clipsToBounds = true
            if let clubIcon = clubs[indexPath.row].clubPicture {
                
                clubIconView.image = clubIcon
            }
            
        }
        
        if let nameLabel = cell?.viewWithTag(2) as? UILabel {
            nameLabel.text = clubs[indexPath.row].clubName

        }
        
        if let positionLabel = cell?.viewWithTag(3) as? UILabel {
            if let position = clubs[indexPath.row].position {
                positionLabel.text = position
            } else {
                positionLabel.text = ""
            }
        }
        
        if let dateLabel = cell?.viewWithTag(4) as? UILabel {
            if let date = clubs[indexPath.row].dateJoined {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                dateLabel.text = formatter.string(from: date)
            } else {
                dateLabel.text = ""
            }
        }
        
        /*if let image = cell?.viewWithTag(5) as? UIImageView {
            if(clubs[indexPath.row].favorited) {
                image.image = UIImage(named: "star-filled")
            } else {
                image.image = UIImage(named: "star-hollow")
            }
        }*/
        
        return cell!
        


    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubs.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    


}
