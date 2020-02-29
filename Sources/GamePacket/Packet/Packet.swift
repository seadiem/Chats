import Foundation

public struct ServerPlayer: Hashable, Codable {
    public let name: String
    public init(name: String) {
        self.name = name
    }
}

public struct ServerMatch {
    public var players: Set<ServerPlayer>
    public init(players: Set<ServerPlayer>) {
        self.players = players
    }
}

public struct Request: Codable {
    public enum RequestIntent: Int, Codable {
        case needMatch
        case takeYourMatchData
        case pingServer
    }
    public var type: RequestIntent
    public var player: ServerPlayer
    public var data: Data?
    public init(type: RequestIntent, player: ServerPlayer) {
        self.type = type
        self.player = player
    }
}

public struct Response: Codable {
    
    public enum Domain: Int, Codable {
        case serverState
        case textMessage
        case error
    }
    
    public enum ServerState: Int, Codable {
        case hold
        case creatingMatch
        case matchStarted
        case matchFinished
        case matching
    }
    
    public let domain: Domain
    public var serverState: ServerState?
    public var gameData: GameData?
    public var text: String?
    
    public init(domain: Domain) {
        self.domain = domain
    }
}

public struct GameData: Codable {
    public let owner: ServerPlayer
    public let data: Data
}

