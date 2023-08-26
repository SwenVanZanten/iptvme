import Foundation
import XtreamCodesKit
import CloudKit

struct Channel: Identifiable {
    var id: CKRecord.ID?
    let name: String
    let categoryId: CKRecord.ID
    let liveStream: LiveStream
    
    init(name: String, categoryId: CKRecord.ID, liveSteam: LiveStream)
    {
        self.name = name
        self.categoryId = categoryId
        self.liveStream = liveSteam
    }
    
    init(record: CKRecord)
    {
        self.init(
            name: record["name"] as! String,
            categoryId: (record["category"] as! CKRecord.Reference).recordID,
            liveSteam: .init(
                id: record["identifier"] as! Int,
                number: record["number"] as! Int,
                name: record["name"] as! String,
                icon: URL(string: record["icon"] ?? ""),
                epgChannelId: record["epgChannelId"] as? String,
                added: record["added"] as! String,
                categoryId: record["categoryId"] as! String,
                customSid: record["customSid"] as? String,
                tvArchive: record["tvArchive"] as! Bool,
                directSource: record["directSource"] as! String,
                tvArchiveDuration: record["tvArchiveDuration"] as? String
            )
        )
        
        self.id = record.recordID
    }
}
