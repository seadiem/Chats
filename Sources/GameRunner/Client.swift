import GamePacket

struct ClientRunner {
    func run() {
        
        do {
            let app = try NetworkApp()
            app.play()
        } catch let error {
            print(error)
        }
        
    }
}
