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

public struct RequestGen: Codable {
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

public struct GameElement<Element> {
    public let owner: ServerPlayer
    public let gameElement: Element
}

extension GameElement: Codable where Element: Codable {}

public struct ResponseGen<Element> {
    
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
    public var gameData: GameElement<Element>?
    public var text: String?
    
    public init(domain: Domain) {
        self.domain = domain
    }
}

extension ResponseGen: Codable where Element: Codable {}
