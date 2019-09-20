

public struct YardMessage: Codable, CustomStringConvertible {
    
    let from: String
    let text: String
    public init(from: String, text: String) {
        self.from = from
        self.text = text
    }
    
    public var description: String {
        return """
        -
        \(from)
        \(text)
        
        """
    }
    
}
