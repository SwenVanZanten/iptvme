import Foundation
import XtreamCodesKit
import CloudKit

class LiveTVChannelsViewModel: ObservableObject {
    /// The CloudKit container to use.
    private let container = CKContainer(identifier: Config.cloudKitContainerIdentifier)

    /// This sample uses the private database, which requires a logged in iCloud account.
    private lazy var database = container.privateCloudDatabase
    
    static let recordType = "LiveTvChannel"
    
    @Published var category: LiveTVCategory
    @Published var channels: [Channel] = []
    @Published var selectedChannel: Channel? = nil
    
    init(category: LiveTVCategory) {
        self.category = category
        
        fetchChannels(by: category)
    }
    
    func addChannel(_ channel: Channel) async {
        let record = CKRecord(recordType: LiveTVChannelsViewModel.recordType)
        record["category"] = CKRecord.Reference(recordID: channel.categoryId, action: .deleteSelf)
        record["name"] = channel.name
        record["identifier"] = channel.liveStream.id
        record["number"] = channel.liveStream.number
        record["icon"] = channel.liveStream.icon?.absoluteString ?? ""
        record["epgChannelId"] = channel.liveStream.epgChannelId
        record["added"] = channel.liveStream.added
        record["categoryId"] = channel.liveStream.categoryId
        record["customSid"] = channel.liveStream.customSid
        record["tvArchive"] = channel.liveStream.tvArchive
        record["directSource"] = channel.liveStream.directSource
        record["tvArchiveDuration"] = channel.liveStream.tvArchiveDuration
        
        do {
            let record = try await database.save(record)
            let savedChannel = Channel(record: record)

            DispatchQueue.main.async {
                self.channels.append(savedChannel)
            }
        } catch let functionError {
            print(functionError)
        }
    }

    func updateChannel(_ channel: Channel) {
        //
    }

    func deleteChannel(_ channel: Channel) {
        //
    }

    func fetchChannels(by category: LiveTVCategory) {
        let recordToMatch = CKRecord.Reference(recordID: category.id!, action: .deleteSelf)
        let predicate = NSPredicate(format: "category == %@", recordToMatch)
        let query = CKQuery(recordType: LiveTVChannelsViewModel.recordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        database.fetch(withQuery: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.channels = []
                
                switch result {
                case .success(let records):
                    for record in records.matchResults {
                        self?.handleChannelRecord(recordResult: record.1)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func handleChannelRecord(recordResult: Result<CKRecord, Error>) {
        switch recordResult {
        case .success(let channel):
            DispatchQueue.main.async {
                self.channels.append(.init(record: channel))
            }
        case .failure(let error):
            print(error)
        }
    }
}
