import ChatYard
import Foundation

print("Представьтесь:")
let message = readLine()
var name = message ?? "User"

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
