import Socket

public struct Leash {
    public let clientSocket: Socket
    public init() throws {
        clientSocket = try Socket.create(family: Socket.ProtocolFamily.unix,
                                         type: Socket.SocketType.stream,
                                         proto: Socket.SocketProtocol.unix)
        print("trying to connect...")
        Foldermaker().make()
        try clientSocket.connect(to: Foldermaker().socketpath)
        print("connection estabilish...")
    }
}
