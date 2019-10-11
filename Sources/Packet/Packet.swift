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

public enum ServerStatus: Int, Codable {
    case hold
    case creatingMatch
    case matching
}

public struct Request: Codable {
    public enum RequestIntent: Int, Codable {
        case needMatch
        case matchData
        case pingServer
    }
    public var type: RequestIntent
    public var player: ServerPlayer
    public init(type: RequestIntent, player: ServerPlayer) {
        self.type = type
        self.player = player
    }
}

public struct Response: Codable {
    
    public enum Domain: Int, Codable {
        case serverStatus
        case matchCreatedWaitingPlayers
        case readyToMatch
        case matchData
        case error
    }
    
    public let domain: Domain
    public var status: ServerStatus?
    
    public init(domain: Domain) {
        self.domain = domain
    }
}


