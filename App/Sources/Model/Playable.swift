import Foundation

struct Playable: Identifiable, Hashable, Decodable, Encodable {
    var id = UUID()
    let name: String
    let url: URL
}
