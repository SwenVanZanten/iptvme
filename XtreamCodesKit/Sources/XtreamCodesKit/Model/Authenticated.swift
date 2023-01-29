import Foundation

public struct Authenticated: Decodable {
    public var userInfo: UserInfo
    public var serverInfo: ServerInfo
    
    enum CodingKeys: String, CodingKey {
        case userInfo = "userInfo"
        case serverInfo = "serverInfo"
    }
    
    public struct ServerInfo: Decodable {
        public var url: String
        public var port: String
        public var httpsPort: String
        public var serverProtocol: String
        public var rtmpPort: String
        public var timezone: String
        public var timestampNow: Int
        public var timeNow: String
        
        enum CodingKeys: CodingKey {
            case url
            case port
            case httpsPort
            case serverProtocol
            case rtmpPort
            case timezone
            case timestampNow
            case timeNow
        }
    }

    public struct UserInfo: Decodable {
        public var username: String
        public var password: String
        public var message: String?
        public var auth: Int
        public var status: String
        public var expirationDate: String
        public var isTrial: Bool
        public var activeConnections: Int
        public var createdAt: String
        public var maxConnections: Int
        public var allowedOutputFormats: [String]
        
        enum CodingKeys: String, CodingKey {
            case username
            case password
            case message
            case auth
            case status
            case expirationDate = "expDate"
            case isTrial
            case activeConnections = "activeCons"
            case createdAt
            case maxConnections
            case allowedOutputFormats
        }
        
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<Authenticated.UserInfo.CodingKeys> = try decoder.container(keyedBy: Authenticated.UserInfo.CodingKeys.self)
            self.username = try container.decode(String.self, forKey: Authenticated.UserInfo.CodingKeys.username)
            self.password = try container.decode(String.self, forKey: Authenticated.UserInfo.CodingKeys.password)
            self.message = try container.decodeIfPresent(String.self, forKey: Authenticated.UserInfo.CodingKeys.message)
            self.auth = try container.decode(Int.self, forKey: Authenticated.UserInfo.CodingKeys.auth)
            self.status = try container.decode(String.self, forKey: Authenticated.UserInfo.CodingKeys.status)
            self.expirationDate = try container.decode(String.self, forKey: Authenticated.UserInfo.CodingKeys.expirationDate)
            self.isTrial = try container.decode(String.self, forKey: Authenticated.UserInfo.CodingKeys.isTrial) == "1"
            self.activeConnections = Int(try container.decode(String.self, forKey: Authenticated.UserInfo.CodingKeys.activeConnections)) ?? 0
            self.createdAt = try container.decode(String.self, forKey: Authenticated.UserInfo.CodingKeys.createdAt)
            self.maxConnections = Int(try container.decode(String.self, forKey: Authenticated.UserInfo.CodingKeys.maxConnections)) ?? 0
            self.allowedOutputFormats = try container.decode([String].self, forKey: Authenticated.UserInfo.CodingKeys.allowedOutputFormats)
        }
    }
}
