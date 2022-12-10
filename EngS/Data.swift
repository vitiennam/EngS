//
//  Data.swift
//  EngS
//
//  Created by vi nam on 17/11/2022.
//

import Foundation
import RealmSwift
import UIKit

class EngData {
    var wordList : [String] = []
    var wordListFlashCard : [String] = []
}
class userDataClass: ObservableObject {
    var searchedWord : [String] = []
    var flashCardWord : [String] = []
    @Published var userSearchedWord : [String] = []
}
class word: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id:String
    @Persisted var ownerId = ""
    @Persisted var word: String
}
class UserDataClassRealm: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: UUID
//    @Persisted var ownerId = UIDevice.current.identifierForVendor!.uuidString
    @Persisted var ownerId = ""
    @Persisted var userSearchedWord : RealmSwift.List<String>
    @Persisted var deviceName = UIDevice.current.name

}

func fileURL(fileName: String) throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent(fileName)
    }
//func findUrl(fileName: String) -> String {
//    let fileU = Bundle.main.path(forResource: fileName, ofType: "json", inDirectory: "data")
//}
func load(fileName: String) -> [String] {
    
    do{
//        let fileURL = try fileURL(fileName: fileName)
//        let fileURL = url
//        guard let fileURL1 = Bundle.main.path(forResource: fileName, ofType: "json") else {
//            return []
//        }
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            
            return [] }
            
//        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
//
//                            return []
//                        }
        let file = try FileHandle(forReadingFrom: fileURL)
        let wordsList = try JSONDecoder().decode([String].self, from: file.availableData)
        return wordsList
    } catch {
        let err = error
        return []
    }
    
}
func loadArrayFile (fileName:String)-> [String] {
    do {
        let fileURL = try fileURL(fileName: fileName)
        let file = try FileHandle(forReadingFrom: fileURL)
        let wordsList = try JSONDecoder().decode([String].self, from: file.availableData)
        return wordsList
    } catch {
        let err = error
        return []
    }
}
func saveArrayFile(fileName:String, dataFile: [String]) -> Bool {
    do {
        let fileURL = try fileURL(fileName: fileName)
        let data = try JSONEncoder().encode(dataFile)
        try data.write(to: fileURL)
        return true
    } catch {
        let err = error
        return false
    }
 
    
}
