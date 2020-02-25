struct Starter {
    func start() {
        let args = CommandLine.arguments
        if args.contains("Client") {
            ClientRunner().run()
        } else if args.contains("Server") {
            print("server run")
            ServerRunner().run()
        }
    }
}
