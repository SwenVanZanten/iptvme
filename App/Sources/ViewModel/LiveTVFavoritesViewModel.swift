import Foundation
import CloudKit
import XtreamCodesKit

class LiveTVFavoritesViewModel: ObservableObject {
    /// The CloudKit container to use.
    private let container = CKContainer(identifier: Config.cloudKitContainerIdentifier)

    /// This sample uses the private database, which requires a logged in iCloud account.
    private lazy var database = container.privateCloudDatabase
    
    static let recordType = "LiveTvFavorite"
    let subscription: Subscription
    
    @Published var favorites: [Favorite] = []
    
    init(subscription: Subscription) {
        self.subscription = subscription
    }
    
    func addFavorite(favorite: Favorite) async {
        let record = CKRecord(recordType: LiveTVChannelsViewModel.recordType)
        record["subscription"] = CKRecord.Reference(recordID: favorite.subscriptionId, action: .deleteSelf)
        record["name"] = favorite.name
        record["identifier"] = favorite.liveStream.id
        record["number"] = favorite.liveStream.number
        record["icon"] = favorite.liveStream.icon?.absoluteString ?? ""
        record["epgChannelId"] = favorite.liveStream.epgChannelId
        record["added"] = favorite.liveStream.added
        record["categoryId"] = favorite.liveStream.categoryId
        record["customSid"] = favorite.liveStream.customSid
        record["tvArchive"] = favorite.liveStream.tvArchive
        record["directSource"] = favorite.liveStream.directSource
        record["tvArchiveDuration"] = favorite.liveStream.tvArchiveDuration
        
        do {
            let record = try await database.save(record)
            let savedFavorite = Favorite(record: record)

            DispatchQueue.main.async {
                self.favorites.append(savedFavorite)
            }
        } catch let functionError {
            print(functionError)
        }
    }
    
    func updateFavorite(favorite: Favorite) {
        
    }
    
    func removeFavorite(favorite: Favorite) {
        
    }
    
    func fetchFavorites() {
        guard let subscriptionRecordID = subscription.recordID else {
            return
        }
        
        let recordToMatch = CKRecord.Reference(recordID: subscriptionRecordID, action: .deleteSelf)
        let predicate = NSPredicate(format: "subscription == %@", recordToMatch)
        let query = CKQuery(recordType: LiveTVFavoritesViewModel.recordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        self.favorites = []
        
        database.fetch(withQuery: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let records):
                    for record in records.matchResults {
                        self?.handleRecord(recordResult: record.1)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func handleRecord(recordResult: Result<CKRecord, Error>) {
        switch recordResult {
        case .success(let favorite):
            self.favorites.append(.init(record: favorite))
        case .failure(let error):
            print(error)
        }
    }
}
