import Foundation
import XtreamCodesKit
import Cache

class ContentViewModel: ObservableObject {
    @Published var imageStorage: Storage<String, Image>
    @Published var api: Api = Api(host: "", username: "", password: "")

    @Published var selectedTab: String = "Live TV"
    @Published var minifiedPlayer: Bool = false
    
    init() {
        let diskConfig = DiskConfig(name: "image-store", expiry: .seconds(600))
        let memoryConfig = MemoryConfig(expiry: .seconds(600))
        
        self.imageStorage = try! Storage<String, Image>(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forImage()
        )
        try! imageStorage.removeExpiredObjects()
    }
}
