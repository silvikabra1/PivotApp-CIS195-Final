//
//  Club.swift
//  Pivot
//
//  Created by Silvi Kabra on 4/13/20.
//  Copyright © 2020 Silvi Kabra. All rights reserved.
//

import Foundation
import UIKit

// Model for "ClubItem"

struct Club {
    let clubName: String
    let clubPicture: UIImage?
    let position: String?
    let dateJoined: Date?
    var linkedApps: [String]?
    var tokens: [String]?
    var favorited: Bool
    var groupMeGroup: String?
}

protocol Group {
    var groupName: String { get }
    var linkedApp: String { get }
    var token: String { get }
}

