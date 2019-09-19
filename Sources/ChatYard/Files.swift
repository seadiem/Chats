import Foundation
import Files


struct Foldermaker {
    
    func make() {
        do {
            _ = try Folder(path: path)
        } catch {
            print("Error folder creating")
        }
    }
    
    var path: String {
        let dict = ProcessInfo.processInfo.environment
        let path = dict["HOME"]!
        return "\(path)/Desktop/Chat"
    }
    
    var socketpath: String {
        return "\(path)/chatport"
    }
}
