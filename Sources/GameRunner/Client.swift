import GamePacket

struct ClientRunner {
    func run() {
        
        do {
            let app = try NetworkApp { response in print(response) }
            app.play()
        } catch let error {
            print(error)
        }
        
    }
}
