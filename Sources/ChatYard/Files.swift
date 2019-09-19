import Foundation
import Files


public struct Foldermaker {
    
    public init() {}
    
    public func make() {
        do {
            let folder = try Folder(path: path)
            _ = try folder.createSubfolder(named: "Chats")
        } catch let error {
            print("Error folder creating: \(error)")
        }
    }
    
    public var path: String {
        let dict = ProcessInfo.processInfo.environment
        let path = dict["HOME"]!
        return "\(path)/Desktop/"
    }
    
    public var socketpath: String {
        return "\(path)/chatport"
    }
}
