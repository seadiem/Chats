import Socket
import Foundation
import Files

public struct Kennel {
    
    public let serverSocket: Socket
    public var incomsocket: Socket?
    let handle: (String?) -> String
    
    public init(handle: @escaping (String?) -> String ) throws {
        self.handle = handle
        serverSocket = try Socket.create(family: Socket.ProtocolFamily.unix,
                                         type: Socket.SocketType.stream,
                                         proto: Socket.SocketProtocol.unix)
        Foldermaker().make()
        try serverSocket.listen(on: Foldermaker().socketpath)
    }
    
}
