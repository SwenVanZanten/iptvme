import SwiftUI
import XtreamCodesKit
import CloudKit

class SubscriptionViewModel: ObservableObject {
    enum SubscriptionViewModelError: Error {
        case noRecordIDSetError(subscription: Subscription)
    }
    
    /// The CloudKit container to use.
    private let container = CKContainer(identifier: Config.cloudKitContainerIdentifier)

    /// This sample uses the private database, which requires a logged in iCloud account.
    private lazy var database = container.privateCloudDatabase
    
    @Published var subscriptions: [Subscription] = []
    @Published var selectedSubscription: Subscription? = nil
    
    init() {
        fetchSubscriptions()
    }
    
    func addSubscription(subscription: Subscription) async throws
    {
        let record = CKRecord(recordType: "Subscription")
        record["name"] = subscription.name
        record["username"] = subscription.username
        record["key"] = subscription.password
        record["host"] = subscription.host
        
        do {
            try await database.save(record)
            
            DispatchQueue.main.async {
                self.subscriptions.append(Subscription(record: record))
            }
        } catch let functionError {
            print(functionError)
        }
    }
    
    func updateSubscription(subscription: Subscription) async throws
    {
        // Could be add aswell...
    }
    
    func deleteSubscription(subscription: Subscription) async throws
    {
        guard let recordID = subscription.recordID else {
            throw SubscriptionViewModelError.noRecordIDSetError(subscription: subscription)
        }

        DispatchQueue.main.async {
            let itemIndex = self.subscriptions.firstIndex { sub in
                return subscription == sub
            }

            if let itemIndex = itemIndex {
                self.subscriptions.remove(at: itemIndex)
            }
        }

        try await database.deleteRecord(withID: recordID)
    }
    
    func fetchSubscriptions()
    {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Subscription", predicate: predicate)
        
        database.fetch(withQuery: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.subscriptions = []
                
                switch result {
                case .success(let records):
                    for record in records.matchResults {
                        self?.handleSubscriptionRecord(recordResult: record.1)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func handleSubscriptionRecord(recordResult: Result<CKRecord, Error>) {
        switch recordResult {
        case .success(let subscription):
            self.subscriptions.append(.init(record: subscription))
        case .failure(let error):
            print(error)
        }
    }
}

extension Subscription {
    private static var _recordIDComputedProperty = [String: CKRecord.ID]()

    var recordID: CKRecord.ID? {
        get {
            return Subscription._recordIDComputedProperty[self.hashValue.description] ?? nil
        }
        set(newValue) {
            Subscription._recordIDComputedProperty[self.hashValue.description] = newValue
        }
    }

    init(record: CKRecord) {
        self.init(
            name: record["name"] as! String,
            username: record["username"] as! String,
            password: record["key"] as! String,
            host: record["host"] as! String
        )
        
        self.recordID = record.recordID
    }
}
