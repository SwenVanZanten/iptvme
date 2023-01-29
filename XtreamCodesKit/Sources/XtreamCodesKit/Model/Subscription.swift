import Foundation

public struct Subscription: Hashable, Identifiable, Decodable, Encodable {
    public var id = UUID()
    public var name: String
    public var username: String
    public var password: String
    public var host: String
    
    public init(name: String, username: String, password: String, host: String) {
        self.name = name
        self.username = username
        self.password = password
        self.host = host
    }
}
