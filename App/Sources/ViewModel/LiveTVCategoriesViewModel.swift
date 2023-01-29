import Foundation
import CloudKit

class LiveTVCategoriesViewModel: ObservableObject {
    /// The CloudKit container to use.
    private let container = CKContainer(identifier: Config.cloudKitContainerIdentifier)

    /// This sample uses the private database, which requires a logged in iCloud account.
    private lazy var database = container.privateCloudDatabase
    
    static let recordType = "LiveTvCategory"

    @Published var categories: [LiveTVCategory] = []
    @Published var selectedCategory: LiveTVCategory? = nil

    func addCategory(_ category: LiveTVCategory) async {
        let record = CKRecord(recordType: LiveTVCategoriesViewModel.recordType)
        record["name"] = category.name
        record["image"] = category.image
        record["systemImage"] = category.systemImage
        record["color"] = category.color.description
        
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

    func deleteCategory(_ category: LiveTVCategory) {
        //
    }

    func fetchGategories() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: LiveTVCategoriesViewModel.recordType, predicate: predicate)
        
        database.fetch(withQuery: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.categories = []
                
                switch result {
                case .success(let records):
                    for record in records.matchResults {
                        self?.handleCategoryRecord(recordResult: record.1)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func handleCategoryRecord(recordResult: Result<CKRecord, Error>) {
        switch recordResult {
        case .success(let category):
            DispatchQueue.main.async {
                self.categories.append(.init(record: category))
            }
        case .failure(let error):
            print(error)
        }
    }
}
