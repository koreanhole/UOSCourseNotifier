//
//  CourseData.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/07.
//  Copyright © 2020 권순형. All rights reserved.
//

import Foundation
import Firebase

class CourseData: Codable {
    
    
    static let sharedCourse = CourseData()
    var savedData = [[String:String]]()
    
    static let archiveUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("note_test").appendingPathExtension("plist")
    
    static func saveToFile(data: [[String:String]]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedEmojis = try? propertyListEncoder.encode(data)
        
        try? encodedEmojis?.write(to: CourseData.archiveUrl, options: .noFileProtection)
    }
    static func loadFromFile() -> [[String:String]] {
        var emojisFromDisk: [[String:String]] = [[:]]
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedEmojiData = try? Data(contentsOf: CourseData.archiveUrl),
            let decodedEmojis = try? propertyListDecoder.decode([[String:String]].self.self, from: retrievedEmojiData){
                emojisFromDisk = decodedEmojis
        }
        return emojisFromDisk
    }
    
    static func getCourseInfoFB(subject: [String:String], completion: @escaping ([String:String]) -> Void){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        if subject["subject_div"] == "전공선택" || subject["subject_div"] == "전공필수" {
            let boardRef = ref.child("course").child("전공").child(subject["subject_nm"]!+subject["class_div"]!)
            boardRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let courseDict = snapshot.value as? [String:String] {
                    completion(courseDict)
                }
            })
        } else {
            let boardRef = ref.child("course").child("교양").child(subject["subject_nm"]!+subject["class_div"]!)
            boardRef.observe(_: .value, with: { (snapshot) in
                if let courseDict = snapshot.value as? [String:String] {
                    completion(courseDict)
                }
            })
        }
    }
}
