import ChatYard
import Foundation

struct Client {
    
    let client = try! ChatClientData(name: "First") { data in
        print(data)
    }
    
    func run() {
        while true {
            let line = readLine()
            print(line as Any)
        }
    }
}


public struct ChatClientData {
    
    let name: String
    let leash: Leash
    let handler: (Data) -> Void
    let queue: DispatchQueue
    
    public init(name: String, handler: @escaping (Data) -> Void) throws {
        self.name = name
        self.leash = try Leash()
        self.handler = handler
        self.queue = DispatchQueue(label: "socket listener")
    }
    
    public func send(data: Data) {
        do { try leash.clientSocket.write(from: data) }
        catch let error { print(error) }
    }
    
    public func listen() {
        while true {
            do {
                var data = Data()
                _ = try self.leash.clientSocket.read(into: &data)
                self.handler(data)
            } catch let error {
                print(error)
            }
        }
    }
}
