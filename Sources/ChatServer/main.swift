import ChatYard
import Foundation
import Socket


var sockets = [Socket]() {
    didSet {
        for item in sockets {
            let socketsbrowcast = DispatchQueue(label: "\(item.socketfd)")
            socketsbrowcast.async {
                while true {
                    do {
                        let message = try item.readString()
                        guard let line = message else { continue  }
                        for item in sockets {
                            try item.write(from: line)
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }
        }
    }
}


let queue = DispatchQueue(label: "keyboard listen")
queue.async {
    
    keyinput: while true {
        print("input message...")
        let message = readLine()
        guard let line = message else { continue keyinput }
        for item in sockets {
            do {
                try item.write(from: "Модератор: " + line)
            } catch let error {
                print(error)
                continue keyinput
            }
        }
    }
}



do {
    let kennel = try Kennel { $0 ?? "no text" }
    print("wait client socket...")
    meetsocket: while true {
        let newSocket = try kennel.serverSocket.acceptClientConnection() // ждём клиент
        sockets.append(newSocket)
    }
} catch let error {
    print(error)
}
