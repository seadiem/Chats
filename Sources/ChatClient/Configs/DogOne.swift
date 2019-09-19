import ChatYard
import Foundation

public struct ChatClientData {
    
    let name: String
    let leash: Leash
//    let handler: (Data) -> Void
//    let queue: DispatchQueue
    
    public init(name: String) {
        self.name = name
        self.leash = try! Leash()
//        self.handler = handler
//        self.queue = DispatchQueue(label: "socket listener")
    }
    
    func send(data: Data) {
        do { try leash.clientSocket.write(from: data) }
        catch let error { print(error) }
    }
    
    func listen() {
        while true {
            do {
                var data = Data()
                _ = try self.leash.clientSocket.read(into: &data)
//                self.handler(data)
            } catch let error {
                print(error)
            }
        }
    }    
}
