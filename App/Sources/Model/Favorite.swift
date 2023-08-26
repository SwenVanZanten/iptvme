import Foundation
import XtreamCodesKit
import CloudKit

struct Favorite {
    var id: CKRecord.ID?
    let name: String
    let subscriptionId: CKRecord.ID
    let liveStream: LiveStream
    
    init(name: String, subscriptionId: CKRecord.ID, liveSteam: LiveStream)
    {
        self.name = name
        self.subscriptionId = subscriptionId
        // don't store in db
        self.liveStream = liveSteam
    }
    
    init(record: CKRecord)
    {
        self.init(
            name: record["name"] as! String,
            subscriptionId: (record["subscription"] as! CKRecord.Reference).recordID,
            // don't store in db
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
