import SwiftUI
import XtreamCodesKit
import CloudKit

struct LiveTVCategory: Identifiable {
    static let systemImages: [String] = [
        "tv",
        "video",
        "mic",
        "waveform",
        "message",
        "cloud.sun",
        "cloud.snow",
        "car",
        "bolt.car",
        "bicycle",
        "sailboat",
        "flag.checkered",
        "figure.walk",
        "figure.run",
        "figure.basketball",
        "figure.baseball",
        "figure.badminton",
        "figure.skiing.downhill",
        "sportscourt",
        "dumbbell",
        "soccerball",
        "basketball",
        "baseball",
        "football",
        "tennis.racket",
        "tennisball",
        "trophy",
        "house",
        "camera",
        "gamecontroller",
        "network",
        "airplane",
        "globe.europe.africa.fill",
        "mountain.2",
        "tree",
        "atom",
        "18.circle"
    ]
    
    static let images: [String] = [
        "Baseball 1",
        "Baseball 2",
        "Basketball 1",
        "Belgian 1",
        "Dancing 1",
        "Dutch 1",
        "Dutch 2",
        "Football 1",
        "Football 2",
        "French 1",
        "French 2",
        "German 1",
        "German 2",
        "Kids 1",
        "Kids 2",
        "Kids 3",
        "Racing 1",
        "Racing 2",
        "Racing 3",
        "Rugby 1",
        "Rugby 2",
        "Running",
        "Spanish",
        "Stadium",
        "TV",
        "UK 1",
        "UK 2",
        "Wintersport 1",
        "Adult"
    ]
    
    var id: CKRecord.ID?
    let subscriptionId: CKRecord.ID
    let name: String
    let image: String
    let color: Color
    let systemImage: String
    
    init(subscriptionId: CKRecord.ID, name: String, image: String, color: Color, systemImage: String = "tv") {
        self.subscriptionId = subscriptionId
        self.name = name
        self.image = image
        self.color = color
        self.systemImage = systemImage
    }

    init(record: CKRecord) {
        self.id = record.recordID
        self.subscriptionId = (record["subscription"] as! CKRecord.Reference).recordID
        self.name = record["name"] as! String
        self.image = record["image"] as! String
        self.color = Color(hex: record["color"] as! String) ?? .blue
        self.systemImage = record["systemImage"] as! String
    }
    
    mutating func setId(_ id: CKRecord.ID) {
        self.id = id
    }
}
