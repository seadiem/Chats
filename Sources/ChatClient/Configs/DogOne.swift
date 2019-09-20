import ChatYard
import Foundation

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

public struct ChatClientString {
    
    public init() {}
    
    public func work() {
        print("Представьтесь:")
        let message = readLine()
        let name = message ?? "User"
        
        do {
            let dog = try Leash()
        
            let queue = DispatchQueue(label: "keyboard listen")
            queue.async {
                keyinput: while true {
                    let message = readLine()
                    guard let line = message else { continue keyinput }
                    do { try dog.clientSocket.write(from: name + ": " + line) }
                    catch let error { print(error) }
                }
            }
        
            while true {
                let incom = try dog.clientSocket.readString()
                print("from sever: \(incom ?? "")")
            }
        
        } catch let error {
            print(error)
        }
    }
}

public struct ChatClientDataKeyboard {
    
    public init() {}
    
    public func work() {
        print("Представьтесь:")
        let message = readLine()
        let name = message ?? "User"
        
        do {
            let dog = try Leash()
        
            let queue = DispatchQueue(label: "keyboard listen")
            queue.async {
                keyinput: while true {
                    let message = readLine()
                    guard let line = message else { continue keyinput }
                    
                    let bee = YardMessage(from: name, text: line)
                    let encoder = JSONEncoder()
                    let data = try! encoder.encode(bee)
                    
                    do { try dog.clientSocket.write(from: data)}
                    catch let error { print(error) }
                }
            }
        
            while true {
                var data = Data()
                _ = try dog.clientSocket.read(into: &data)
                let restorebee = try! JSONDecoder().decode(YardMessage.self, from: data)
                print(restorebee)
            }
        
        } catch let error {
            print(error)
        }
    }
}
