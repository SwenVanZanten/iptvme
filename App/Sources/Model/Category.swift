//
//  Category.swift
//  IPTV Me
//
//  Created by Swen van Zanten on 14/09/2022.
//

import SwiftUI
import XtreamCodesKit
import CloudKit

var exampleCategories: [LiveTVCategory] = [
    .init(name: "Nederlands", image: "Nederlands", color: .orange, systemImage: "tv"),
    .init(name: "Sports", image: "Sports", color: .green, systemImage: "soccerball"),
    .init(name: "Spaans", image: "Spaans", color: .yellow, systemImage: "tv"),
    .init(name: "Adult", image: "Adult", color: .red, systemImage: "18.circle.fill"),
]

struct LiveTVCategory: Identifiable {
    var id: CKRecord.ID?
    let name: String
    let image: String
    let color: Color
    let systemImage: String
    
    init(name: String, image: String, color: Color, systemImage: String = "tv") {
        self.name = name
        self.image = image
        self.color = color
        self.systemImage = systemImage
    }

    init(record: CKRecord) {
        self.id = record.recordID
        self.name = record["name"] as! String
        self.image = record["image"] as! String
        self.color = .blue
        self.systemImage = record["systemImage"] as! String
    }
    
    mutating func setId(_ id: CKRecord.ID) {
        self.id = id
    }
}
