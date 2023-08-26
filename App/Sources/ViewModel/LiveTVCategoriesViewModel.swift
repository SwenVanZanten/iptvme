import SwiftUI
import CloudKit
import XtreamCodesKit

class LiveTVCategoriesViewModel: ObservableObject {
    enum LiveTVCategoriesViewModelError: Error {
        case subscriptionMissesRecordID(subscription: Subscription)
        case categoryMissesRecordID(category: LiveTVCategory)
    }
    
    /// The CloudKit container to use.
    private let container = CKContainer(identifier: Config.cloudKitContainerIdentifier)

    /// This sample uses the private database, which requires a logged in iCloud account.
    private lazy var database = container.privateCloudDatabase
    
    static let recordType = "LiveTvCategory"
    let subscription: Subscription
    
    @Published var categories: [LiveTVCategory] = []
    @Published var selectedCategory: LiveTVCategory? = nil
    @Published var currentGrid: LiveTVCategory? = nil

    init(subscription: Subscription) {
        self.subscription = subscription
    }
    
    func addCategory(_ category: LiveTVCategory) async throws {
        guard let subscriptionRecordID = subscription.recordID else {
            throw LiveTVCategoriesViewModelError.subscriptionMissesRecordID(subscription: subscription)
        }
        
        let record = CKRecord(recordType: LiveTVCategoriesViewModel.recordType)
        record["subscription"] = CKRecord.Reference(recordID: subscriptionRecordID, action: .deleteSelf)
        record["name"] = category.name
        record["image"] = category.image
        record["systemImage"] = category.systemImage
        record["color"] = category.color.toHex()
        
        do {
            let record = try await database.save(record)
            let savedCategory = LiveTVCategory(record: record)

            DispatchQueue.main.async {
                self.categories.append(savedCategory)
            }
        } catch let functionError {
            print(functionError)
        }
    }

    func updateCategory(_ category: LiveTVCategory) {
        //
    }

    func deleteCategory(_ category: LiveTVCategory) async throws {
        guard let recordId = category.id else {
            throw LiveTVCategoriesViewModelError.categoryMissesRecordID(category: category)
        }
        
        let record = try await database.deleteRecord(withID: recordId)
        
        DispatchQueue.main.async {
            self.categories = self.categories.filter({ category in
                return category.id != record
            })
        }
    }

    func fetchGategories() {
        guard let subscriptionRecordID = subscription.recordID else {
            return
        }
        
        let recordToMatch = CKRecord.Reference(recordID: subscriptionRecordID, action: .deleteSelf)
        let predicate = NSPredicate(format: "subscription == %@", recordToMatch)
        let query = CKQuery(recordType: LiveTVCategoriesViewModel.recordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        self.categories = []
        
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
        case .success(let category):
            self.categories.append(.init(record: category))
        case .failure(let error):
            print(error)
        }
    }
    
    func getCategoryImages() -> [Image] {
        return LiveTVCategory.images.map { image in
            return Image(image)
        }
    }
}
