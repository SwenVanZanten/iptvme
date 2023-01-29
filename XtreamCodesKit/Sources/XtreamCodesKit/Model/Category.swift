import Foundation

public struct CategoryItem: Hashable, Identifiable, Decodable {
    public var id: String
    public var name: String
    public var parent: Int

    enum CodingKeys: String, CodingKey {
        case id = "categoryId"
        case name = "categoryName"
        case parent = "parentId"
    }
    
    public init(
        id: String,
        name: String,
        parent: Int
    ) {
        self.id = id
        self.name = name
        self.parent = parent
    }
}
