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
    var cultData = [[String:String]]()
    var majorData = [[String:String]]()
    var dept_list = ["건축공학과", "건축학과", "경영학과", "경영학과(EMBA)", "경영학부", "경제학과", "경제학부", "공간정보공학과", "공과대학(학과)", "교통공학과", "교통관리학과", "국사학과", "국어국문학과", "국제관계학과", "국제교육원(학사-과)", "국제도시개발프로그램", "글로벌건설학과", "기계공학과", "기계정보공학과", "도시계획학과", "도시공학과", "도시사회학과", "도시행정학과", "문화예술관광학과", "물리학과", "방재공학과", "법학과", "법학과(LLM)", "법학전문대학원", "부동산학과", "사회복지학과", "산업디자인학과", "생명과학과", "세무학과", "소방방재학과", "수학과", "수학교육전공", "스포츠과학과", "신소재공학과", "역사교육전공", "영어교육전공", "영어영문학과", "음악학과", "재난과학과", "전자전기컴퓨터공학과", "전자전기컴퓨터공학부", "조경학과", "중국어문화학과", "철학과", "첨단녹색도시개발학과", "컴퓨터과학과", "컴퓨터과학부", "토목공학과", "통계학과", "행정학과", "행정학과(EMPA)", "화학공학과", "환경공학과", "환경공학부", "환경원예학과", "환경조각학과"]
    var myDept_list = [String]()

    
    static let myCourseArchiveUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("myCourse").appendingPathExtension("plist")
    static let myDeptArchiveUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("myCourse").appendingPathExtension("plist")
    
    // [String:String]의 딕셔너리 타입의 배열을 저장하는 코드
    static func saveToFile(data: [[String:String]]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedCourseData = try? propertyListEncoder.encode(data)
        
        try? encodedCourseData?.write(to: CourseData.myCourseArchiveUrl, options: .noFileProtection)
    }
    static func loadFromFile() -> [[String:String]] {
        var CourseDataFromDisk: [[String:String]] = [[:]]
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedCourseData = try? Data(contentsOf: CourseData.myCourseArchiveUrl),
            let decodedCourseData = try? propertyListDecoder.decode([[String:String]].self.self, from: retrievedCourseData){
                CourseDataFromDisk = decodedCourseData
        }
        return CourseDataFromDisk
    }
    
    //String타입의 배열을 저장하는 코드
    static func saveListToFile(data: [String]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedCourseData = try? propertyListEncoder.encode(data)
        try? encodedCourseData?.write(to: CourseData.myDeptArchiveUrl, options: .noFileProtection)
    }
    static func loadListFromFile() -> [String] {
        var CourseDataFromDisk: [String] = []
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedCourseData = try? Data(contentsOf: CourseData.myDeptArchiveUrl),
            let decodedCourseData = try? propertyListDecoder.decode([String].self, from: retrievedCourseData){
                CourseDataFromDisk = decodedCourseData
        }
        return CourseDataFromDisk
    }
    
    static func getCourseInfoFB(subject: [String:String], completion: @escaping ([String:String]) -> Void){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        if subject["subject_div"] == "전공선택" || subject["subject_div"] == "전공필수" {
            let boardRef = ref.child("course").child("전공").child(subject["subject_nm"]!).child(subject["class_div"]!)
            boardRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let courseDict = snapshot.value as? [String:String] {
                    completion(courseDict)
                }
            })
        } else if (subject["subject_div"]?.contains("교양") ?? false) {
            let boardRef = ref.child("course").child("교양").child(subject["subject_nm"]!).child(subject["class_div"]!)
            boardRef.observe(_: .value, with: { (snapshot) in
                if let courseDict = snapshot.value as? [String:String] {
                    completion(courseDict)
                }
            })
        }
    }
    static func getCultInfoFB( completion: @escaping ([[String:String]]) -> Void){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let boardRef = ref.child("course").child("교양")
        boardRef.observe(_: .value, with: { (snapshot) in
            var temp_dict = [[String:String]]()
            for snap in snapshot.children {
                let recipeSnap = snap as! DataSnapshot
                let dict = recipeSnap.value as! [String:AnyObject]
                for dict_child in dict {
                    temp_dict.append(dict_child.value as! [String:String])
                }
            }
            completion(temp_dict)
        })
    }
    static func getMajorInfoFB(deptName:String, completion: @escaping ([[String:String]]) -> Void){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let boardRef = ref.child("course").child("전공")
        boardRef.observe(_: .value, with: { (snapshot) in
            var temp_dict = [[String:String]]()
            for snap in snapshot.children {
                let recipeSnap = snap as! DataSnapshot
                let dict = recipeSnap.value as! [String:AnyObject]
                for child in dict.values {
                    let dict_child = child as! [String:String]
                    if dict_child["sub_dept"] == deptName {
                        temp_dict.append(dict_child)
                    }
                }
            }
            completion(temp_dict)
        })
    }
}
