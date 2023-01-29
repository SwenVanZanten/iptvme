import Foundation

enum ApiError: Error {
    case couldntComposeURLFor(call: String)
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public class Api {
    private let jsonDecoder = JSONDecoder()
    
    public let host: String
    public let username: String
    public let password: String

    public var urlString: String {
        return "\(host)/player_api.php?username=\(username)&password=\(password)"
    }
    
    public init(host: String, username: String, password: String) {
        self.host = host
        self.username = username
        self.password = password

        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        self.jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }

    // MARK: Account

    public func authenticate() async throws -> Authenticated {
        guard let url = URL(string: urlString) else {
            throw ApiError.couldntComposeURLFor(call: "authenticate")
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try jsonDecoder.decode(Authenticated.self, from: data)
    }
    
    
    // MARK: Live TV
    
    public func liveTvCategories() async throws -> [CategoryItem] {
        guard let url = URL(string: "\(urlString)&action=get_live_categories") else {
            throw ApiError.couldntComposeURLFor(call: "liveTvCategories")
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try jsonDecoder.decode([CategoryItem].self, from: data)
    }
    
    public func liveTvCategory(category: String) async throws -> [LiveStream] {
        guard let url = URL(string: "\(urlString)&action=get_live_streams&category_id=\(category)") else {
            throw ApiError.couldntComposeURLFor(call: "liveTvCategory")
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try jsonDecoder.decode([LiveStream].self, from: data)
    }
    
    
    // MARK: Movies
    
    public func moviesCategories() async throws -> [CategoryItem] {
        guard let url = URL(string: "\(urlString)&action=get_vod_categories") else {
            throw ApiError.couldntComposeURLFor(call: "moviesCategories")
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try jsonDecoder.decode([CategoryItem].self, from: data)
    }
    
    public func moviesCategory(category: String) async throws -> [Movie] {
        guard let url = URL(string: "\(urlString)&action=get_vod_streams&category_id=\(category)") else {
            throw ApiError.couldntComposeURLFor(call: "moviesCategory")
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try jsonDecoder.decode([Movie].self, from: data)
    }
    
    public func movieInfo(movie: Movie) async throws -> MovieExtended {
        guard let url = URL(string: "\(urlString)&action=get_vod_info&vod_id=\(movie.id)") else {
            throw ApiError.couldntComposeURLFor(call: "movieInfo")
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try jsonDecoder.decode(MovieExtended.self, from: data)
    }
    
    
    // MARK: Series
    
    public func seriesCategories() async throws -> [CategoryItem] {
        guard let url = URL(string: "\(urlString)&action=get_series_categories") else {
            throw ApiError.couldntComposeURLFor(call: "seriesCategories")
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try jsonDecoder.decode([CategoryItem].self, from: data)
    }
    
    public func seriesCategory(category: String) async throws -> [Series] {
        guard let url = URL(string: "\(urlString)&action=get_series&category_id=\(category)") else {
            throw ApiError.couldntComposeURLFor(call: "seriesCategory")
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try jsonDecoder.decode([Series].self, from: data)
    }
    
    public func seriesInfo(series: Series) async throws -> SeriesExtended {
        guard let url = URL(string: "\(urlString)&action=get_series_info&series_id=\(series.id)") else {
            throw ApiError.couldntComposeURLFor(call: "seriesInfo")
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try jsonDecoder.decode(SeriesExtended.self, from: data)
    }
    
    
    // MARK: EPG
    public func epgList(liveStream: LiveStream, limit: Int = 10) async throws -> EpgList {
        guard let url = URL(string: "\(urlString)&action=get_short_epg&limit=\(limit)&stream_id=\(liveStream.id)") else {
            throw ApiError.couldntComposeURLFor(call: "epgList")
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try jsonDecoder.decode(EpgList.self, from: data)
    }
    
    // MARK: Archive
    public func archiveList(liveStream: LiveStream) async throws -> EpgList {
        guard let url = URL(string: "\(urlString)&action=get_simple_data_table&stream_id=\(liveStream.id)") else {
            throw ApiError.couldntComposeURLFor(call: "epgList")
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try jsonDecoder.decode(EpgList.self, from: data)
    }
}
