import Foundation

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public protocol MediaObject: Hashable, Identifiable, Decodable {
    var id: Int { get }
    var number: Int { get }
    var name: String { get }
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct LiveStream: MediaObject, Decodable, Encodable {
    public var id: Int
    public var number: Int
    public var name: String
    public var icon: URL?
    public var epgChannelId: String?
    public var added: String
    public var categoryId: String
    public var customSid: String?
    public var tvArchive: Bool
    public var directSource: String
    public var tvArchiveDuration: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "streamId"
        case number = "num"
        case name
        case icon = "streamIcon"
        case epgChannelId
        case added
        case categoryId
        case customSid
        case tvArchive
        case directSource
        case tvArchiveDuration
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        number = try container.decode(Int.self, forKey: .number)
        name = try container.decode(String.self, forKey: .name)
        icon = URL(string: try container.decode(String.self, forKey: .icon))
        epgChannelId = try? container.decode(String.self, forKey: .epgChannelId)
        added = try container.decode(String.self, forKey: .added)
        categoryId = try container.decode(String.self, forKey: .categoryId)
        customSid = try? container.decode(String.self, forKey: .customSid)
        tvArchive = try container.decode(Int.self, forKey: .tvArchive) == 1
        directSource = try container.decode(String.self, forKey: .directSource)
        tvArchiveDuration = try? container.decode(String.self, forKey: .tvArchiveDuration)
    }
    
    public init(
        id: Int,
        number: Int,
        name: String,
        icon: URL?,
        epgChannelId: String?,
        added: String,
        categoryId: String,
        customSid: String?,
        tvArchive: Bool,
        directSource: String,
        tvArchiveDuration: String?
    ) {
        self.id = id
        self.number = number
        self.name = name
        self.icon = icon
        self.epgChannelId = epgChannelId
        self.added = added
        self.categoryId = categoryId
        self.customSid = customSid
        self.tvArchive = tvArchive
        self.directSource = directSource
        self.tvArchiveDuration = tvArchiveDuration
    }
    
    public func getUrl(api: Api, containerExtension: String = "") -> URL {
        return URL(string: "\(api.host)/live/\(api.username)/\(api.password)/\(self.id)\(containerExtension)")!
    }
    
    /// Get the start time and minutes from the epg list (simple data table)
    public func getTimeshiftUrl(api: Api, startTime: Date, minutes: Int, containerExtension: String = "") -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd:HH:mm:ss"
        let convertedStartTime = dateFormatter.string(from: startTime)
        
        print("\(api.host)/timeshift/\(api.username)/\(api.password)/\(minutes)/\(convertedStartTime)/\(self.id)\(containerExtension)")
        return URL(string: "\(api.host)/timeshift/\(api.username)/\(api.password)/\(minutes)/\(convertedStartTime)/\(self.id)\(containerExtension)")!
    }
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct Movie: MediaObject {
    public var id: Int
    public var number: Int
    public var name: String
    public let icon: URL
    public let rating: String
    public let rating5Based: String
    public let added: Date
    public let categoryId: String
    public let containerExtension: String
    public let customSid: String?
    public let directSource: String
    
    public func getUrl(api: Api) -> URL {
        return URL(string: "\(api.host)/movie/\(api.username)/\(api.password)/\(self.id)\(self.containerExtension)")!
    }
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct Series: MediaObject {
    public var id: Int
    public var number: Int
    public var name: String
    public let cover: URL
    public let plot: String
    public let cast: String
    public let director: String
    public let genre: String
    public let releaseDate: Date
    public let lastModified: Date
    public let rating: String
    public let rating5Based: String
    public var backdropPath: [String] = []
    public let youtubeTrailer: String
    public let episodeRunTime: String
    public let categoryId: String
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct Disposition: Hashable, Decodable {
    public let isDefault: Bool
    public let isDub: Bool
    public let isOriginal: Bool
    public let isComment: Bool
    public let isLyrics: Bool
    public let isKaraoke: Bool
    public let isForced: Bool
    public let isHearingImpaired: Bool
    public let isVisualImpaired: Bool
    public let isCleanEffects: Bool
    public let isAttachedPic: Bool
    public let isTimedThumbnails: Bool
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct Tags: Hashable, Decodable {
    public var creationTime: String? = nil
    public let language: String
    public let handlerName: String
    public var vendorId: String? = nil
    public var encoder: String? = nil
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct Video: Hashable, Identifiable, Decodable {
    public var id = UUID()
    public let index: String
    public let codecName: String
    public let codecLongName: String
    public let profile: String
    public let codecType: String
    public let codecTimeBase: String
    public let codecTagString: String
    public let codecTag: String
    public let width: Int
    public let height: Int
    public let codedWidth: Int
    public let codedHeight: Int
    public let hasBFrames: Bool
    public let sampleAspectRatio: String
    public let displayAspectRatio: String
    public let pixFmt: String
    public let level: Int
    public let chromaLocation: String
    public let refs: Int
    public let isAvc: String
    public let nalLengthSize: String
    public let rFrameRate: String
    public let avgFrameRate: String
    public let timeBase: String
    public let startPts: Int
    public let startTime: String
    public let durationTs: Int
    public let duration: String
    public let bitRate: String
    public let bitsPerRawSample: String
    public let nbFrames: String
    public let disposition: Disposition
    public let tags: Tags
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct Audio: Hashable, Identifiable, Decodable {
    public var id = UUID()
    public let index: String
    public let codecName: String
    public let codecLongName: String
    public let profile: String
    public let codecType: String
    public let codecTimeBase: String
    public let codecTagString: String
    public let codecTag: String
    public let sampleFmt: String
    public let sampleRate: String
    public let channels: Int
    public let channelLayout: String
    public let bitsPerSample: Int
    public let rFrameRate: String
    public let avgFrameRate: String
    public let timeBase: String
    public let startPts: Int
    public let startTime: String
    public let durationTs: Int
    public let duration: String
    public let bitRate: String
    public let bitsPerRawSample: String
    public let nbFrames: String
    public let disposition: Disposition
    public let tags: Tags
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct MovieInfo: Hashable, Identifiable, Decodable {
    public var id = UUID()
    
    public let tmdbId: String
    public let name: String
    public let oName: String
    public let bigCover: String
    public let movieImage: String
    public let releaseDate: Date
    public let youtubeTrailer: String
    public let director: String
    public let actors: String
    public let cast: String
    public let description: String
    public let plot: String
    public let age: String
    public let country: String
    public let genre: String
    public let backdropPath: [String]
    public let durationSeconds: String
    public let duration: String
    public let video: Video
    public let audio: Audio
    public let bitrate: Int
    public let rating: String
    public let status: String
    public let runtime: String
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct MovieData: Hashable, Identifiable, Decodable {
    public let id: String
    public let name: String
    public let added: String
    public let categoryId: String
    public let containerExtension: String
    public let customSid: String?
    public let directSource: String
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct MovieExtended: Hashable, Identifiable, Decodable {
    public var id = UUID()
    public let info: MovieInfo
    public let data: MovieData
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct Season: Hashable, Identifiable, Decodable {
    public let id: Int
    public let airDate: Date
    public let episodeCount: Int
    public let name: String
    public let overview: String
    public let seasonNumber: Int
    public let cover: URL
    public let bigCover: URL
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct EpisodeInfo: Hashable, Identifiable, Decodable {
    public let id: String
    public let airDate: String
    public let crew: String
    public let overview: String
    public let rating: Float
    public let backdropPath: [String]
    public let movieImage: URL
    public let durationSeconds: Int
    public let duration: String
    public let video: Video
    public let audio: Audio
    public let bitrate: Int
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct Episode: Hashable, Identifiable, Decodable {
    public let id: String
    public let episodeNumber: String
    public let title: String
    public let containerExtension: String
    public let info: EpisodeInfo
    public let customSid: String?
    public let added: String
    public let season: Int
    public let directSource: String
    
    public func getUrl(api: Api) -> URL {
        return URL(string: "\(api.host)/series/\(api.username)/\(api.password)/\(self.id)\(self.containerExtension)")!
    }
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct SeriesInfo: Hashable, Identifiable, Decodable {
    public var id = UUID()
    public let name: String
    public let cover: String
    public let plot: String
    public let cast: String
    public let director: String
    public let genre: String
    public let releaseDate: String
    public let lastModified: String
    public let rating: String
    public let rating5Based: String
    public let backdropPath: [String]
    public let youtubeTrailer: String
    public let episodeRunTime: String
    public let categoryId: String
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct SeriesExtended: Hashable, Identifiable, Decodable {
    public var id = UUID()
    public let seasons: [Season]
    public let info: SeriesInfo
    public let episodes: [Episode]
}
