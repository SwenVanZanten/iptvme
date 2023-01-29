//
//  File.swift
//  
//
//  Created by Swen van Zanten on 08/09/2022.
//

import Foundation

public struct EpgItem: Hashable, Identifiable, Decodable {
    public let id: String
    public let epgId: String
    public let title: String
    public let lang: String
    public let start: Date
    public let end: Date
    public let description: String
    public let channelId: String
    public let startTimestamp: String
    public let stopTimestamp: String
    public var hasArchive: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case epgId
        case title
        case lang
        case start
        case end
        case description
        case channelId
        case startTimestamp
        case stopTimestamp
        case hasArchive
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        epgId = try container.decode(String.self, forKey: .epgId)
        lang = try container.decode(String.self, forKey: .lang)
        channelId = try container.decode(String.self, forKey: .channelId)
        startTimestamp = try container.decode(String.self, forKey: .startTimestamp)
        stopTimestamp = try container.decode(String.self, forKey: .stopTimestamp)
        
        let encodedTitle = try container.decode(String.self, forKey: .title)
        title = String(data: Data(base64Encoded: encodedTitle) ?? Data(), encoding: .utf8) ?? encodedTitle
        
        let encodedDesctription = try container.decode(String.self, forKey: .description)
        description = String(data: Data(base64Encoded: encodedDesctription) ?? Data(), encoding: .utf8) ?? encodedDesctription
        
        let startString = try container.decode(String.self, forKey: .start)
        let endString = try container.decode(String.self, forKey: .end)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: lang)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        start = dateFormatter.date(from: startString)!
        end = dateFormatter.date(from: endString)!
        
        hasArchive = (try container.decodeIfPresent(Int.self, forKey: .hasArchive) ?? 0) == 1
    }
    
    public init(
        id: String,
        epgId: String,
        title: String,
        lang: String,
        start: Date,
        end: Date,
        description: String,
        channelId: String,
        startTimestamp: String,
        stopTimestamp: String,
        hasArchive: Bool
    ) {
        self.id = id
        self.epgId = epgId
        self.title = title
        self.lang = lang
        self.start = start
        self.end = end
        self.description = description
        self.channelId = channelId
        self.startTimestamp = startTimestamp
        self.stopTimestamp = stopTimestamp
        self.hasArchive = hasArchive
    }
    
    public var startTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: lang)
        
        return formatter.string(from: start)
    }
    
    public var endTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: lang)
        
        return formatter.string(from: end)
    }
    
    public var startDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: lang)
        
        return formatter.string(from: start)
    }
    
    public var durationTime: String {
        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: start, to: end)
        let hours = String(describing: diffComponents.hour ?? 0)
        let minutes = String(describing: diffComponents.minute ?? 0)
        
        return "\(hours):\(minutes)"
    }
}

public struct EpgList: Hashable, Decodable {
    public var epgListings: [EpgItem] = []
}
