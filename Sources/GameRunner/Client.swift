import GamePacket

struct ClientRunner {
    func run() {
        
        do {
            let app = try NetworkApp { _ in }
            app.play()
        } catch let error {
            print(error)
        }
        
    }
}
