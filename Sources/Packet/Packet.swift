public struct ServerPlayer: Hashable {
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


//enum NetworkPacket {
//    case
//}
