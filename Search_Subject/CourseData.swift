//
//  CourseData.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/07.
//  Copyright © 2020 권순형. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseMessaging

let CURRENT_YEAR = String(Calendar.current.component(.year, from: Date()))
let CURRENT_MONTH = Calendar.current.component(.month, from: Date())
let CURRENT_SEMESTER: String = "A20"

class CourseData: Codable {
    
    
    static let sharedCourse = CourseData()
    //디바이스에 저장하는 내 강의 데이터
    var savedData = [[String:String]]()
    //임시로 사용하는 교양 데이터
    var cultData = [[String:String]]()
    //임시로 사용하는 전공데이터
    var majorData = [[String:String]]()
    var dept_list = ["건축공학과", "건축학과", "경영학과", "경영학과(EMBA)", "경영학부", "경제학과", "경제학부", "공간정보공학과", "공과대학(학과)", "교통공학과", "교통관리학과", "국사학과", "국어국문학과", "국제관계학과", "국제교육원(학사-과)", "국제도시개발프로그램", "글로벌건설학과", "기계공학과", "기계정보공학과", "도시계획학과", "도시공학과", "도시사회학과", "도시행정학과", "문화예술관광학과", "물리학과", "방재공학과", "법학과", "법학과(LLM)", "법학전문대학원", "부동산학과", "사회복지학과", "산업디자인학과", "생명과학과", "세무학과", "소방방재학과", "수학과", "수학교육전공", "스포츠과학과", "신소재공학과", "역사교육전공", "영어교육전공", "영어영문학과", "음악학과", "재난과학과", "전자전기컴퓨터공학과", "전자전기컴퓨터공학부", "조경학과", "중국어문화학과", "철학과", "첨단녹색도시개발학과", "컴퓨터과학과", "컴퓨터과학부", "토목공학과", "통계학과", "행정학과", "행정학과(EMPA)", "화학공학과", "환경공학과", "환경공학부", "환경원예학과", "환경조각학과"]
    //디바이스에 저장하는 학과목록
    var myDept_list = [String]()
    
    //내 강의를 추가하는 함수
    //내 강의가 추가되면 디바이스와 데이터베이스에 저장한다.
    static func saveToMyCourse(data: [String:String]) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let boardRef = ref.child("course").child(CURRENT_YEAR).child(CURRENT_SEMESTER).child("userData")
        if !self.sharedCourse.savedData.contains(data) {
            self.sharedCourse.savedData.append(data)
            self.saveToFile(data: self.sharedCourse.savedData)
            let token = Messaging.messaging().fcmToken!
            let keyValue = data["subject_nm"]! + data["class_div"]!
            boardRef.child(token).updateChildValues([keyValue : keyValue])
            boardRef.child(token).updateChildValues(["device_token" : token])
        }
    }
    //내 강의에서 강좌를 삭제하는 함수
    //내 강의에서 삭제되면 디바이스와 데이터베이스에서 삭제한다.
    static func deleteMyCourse(from: Int) {
        let token = Messaging.messaging().fcmToken
        let data = CourseData.sharedCourse.savedData[from]
        let keyValue = data["subject_nm"]! + data["class_div"]!
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let boardRef = ref.child("course").child(CURRENT_YEAR).child(CURRENT_SEMESTER).child("userData").child(token!).child(keyValue)
        boardRef.removeValue()
        CourseData.sharedCourse.savedData.remove(at: from)
        CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
    }
    
//    static func loadMyCourse() -> [[String:String]] {
//        let token = Messaging.messaging().fcmToken
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//        let boardRef = ref.child("course").child(CURRENT_YEAR).child(CURRENT_SEMESTER).child("userData").child(token!
//    }

    //데이터베이스에서 사용자의 디바이스 토큰을 포함하는 데이터를 저장하는 함수
    /*
    static func updateUserData() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let token = Messaging.messaging().fcmToken!
        let data = CourseData.sharedCourse.savedData
        let boardRef = ref.child("course").child("2020").child("1학기").child("userData")
        var handle: UInt = 0
        if data.count != 0 {
            for index in 0..<data.count {
                let keyValue = data[index]["subject_nm"]! + data[index]["class_div"]!
                handle = boardRef.child(token).observe(_: .value, with: { (snapshot) in
                    if !snapshot.hasChild(keyValue) {
                        boardRef.child(token).updateChildValues([keyValue : keyValue])
                        boardRef.child(token).updateChildValues(["device_token" : token])
                    }
                })
            }
        }
        boardRef.removeObserver(withHandle: handle)
    }
 */
 

    //내 강의를 저장하는 경로
    static let myCourseArchiveUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("myCourse").appendingPathExtension("plist")
    //학과를 저장하는 경로
    static let myDeptArchiveUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("myDeptList").appendingPathExtension("plist")

//     [String:String]의 딕셔너리 타입의 배열을 저장하는 코드
//    내 강의를 디바이스에 저장하는 함수
    static func saveToFile(data: [[String:String]]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedCourseData = try? propertyListEncoder.encode(data)

        try? encodedCourseData?.write(to: CourseData.myCourseArchiveUrl, options: .noFileProtection)
    }
//    디바이스에 저장된 내 강의목록을 불러오는 함수
    static func loadFromFile() -> [[String:String]] {
        var CourseDataFromDisk = [[String:String]]()
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedCourseData = try? Data(contentsOf: CourseData.myCourseArchiveUrl),
            let decodedCourseData = try? propertyListDecoder.decode([[String:String]].self.self, from: retrievedCourseData){
                CourseDataFromDisk = decodedCourseData
        }
        return CourseDataFromDisk
    }
    
    //String타입의 배열을 저장하는 코드
    //학과목록을 저장하는 함수
    static func saveListToFile(data: [String]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedCourseData = try? propertyListEncoder.encode(data)
        try? encodedCourseData?.write(to: CourseData.myDeptArchiveUrl, options: .noFileProtection)
    }
    //디바이스에 저장된 학과 목록을 불러오는 함수
    static func loadListFromFile() -> [String] {
        var CourseDataFromDisk: [String] = []
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedCourseData = try? Data(contentsOf: CourseData.myDeptArchiveUrl),
            let decodedCourseData = try? propertyListDecoder.decode([String].self, from: retrievedCourseData){
                CourseDataFromDisk = decodedCourseData
        }
        return CourseDataFromDisk
    }
    
    // [String:String]타입의 강좌를 입력하면 강의의 '상세정보'를 불러오는 함수
    static func getCourseInfoFB(subject: [String:String], completion: @escaping ([String:String]) -> Void){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        if subject["subject_div"] == "전공선택" || subject["subject_div"] == "전공필수" {
            let boardRef = ref.child("course").child(CURRENT_YEAR).child(CURRENT_SEMESTER).child("전공").child(subject["subject_nm"]! + subject["class_div"]!)
            boardRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let courseDict = snapshot.value as? [String:String] {
                    completion(courseDict)
                }
            })
        } else {
            let boardRef = ref.child("course").child(CURRENT_YEAR).child(CURRENT_SEMESTER).child("교양").child(subject["subject_nm"]! + subject["class_div"]!)
            boardRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let courseDict = snapshot.value as? [String:String] {
                    completion(courseDict)
                }
            })
        }
    }
    
    //교양 강의 목록을 전부 가져오는 함수
    static func getCultInfoFB( completion: @escaping ([[String:String]]) -> Void){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let boardRef = ref.child("course").child(CURRENT_YEAR).child(CURRENT_SEMESTER).child("교양")
        boardRef.observe(_: .value, with: { (snapshot) in
            var temp_dict = [[String:String]]()
            for snap in snapshot.children {
                let recipeSnap = snap as! DataSnapshot
                let dict = recipeSnap.value as! [String:AnyObject]
                temp_dict.append(dict as! [String : String])
            }
            completion(temp_dict)
        })
    }
    
    //강의 제목을 입력하면 강좌정보를 가져오는 함수
    static func getMajorInfoFB(deptName:String, completion: @escaping ([[String:String]]) -> Void){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let boardRef = ref.child("course").child(CURRENT_YEAR).child(CURRENT_SEMESTER).child("전공")
        boardRef.observe(_: .value, with: { (snapshot) in
            var temp_dict = [[String:String]]()
            for snap in snapshot.children {
                let recipeSnap = snap as! DataSnapshot
                let dict = recipeSnap.value as! [String:AnyObject]
                
                //정상적인 강의 항목일 경우
                if dict.count == 19 {
                    let dict_String = dict as! [String:String]
                    if dict_String["sub_dept"] == deptName {
                        temp_dict.append(dict_String)
                    }
                // nested dictionary일 경우
                } else {
                    for (_, values) in dict {
                        let dict_String = values as! [String:String]
                        if dict_String["sub_dept"] == deptName {
                            temp_dict.append(dict_String)
                        }
                    }
                }
            }
            completion(temp_dict)
        })
    }
    
    //사용자에게 발송된 푸시알림의 데이터들을 가져오는 함수
    static func getNotifiactionDataFB(completion: @escaping ([[String:String]]) -> Void){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let token = Messaging.messaging().fcmToken!
        let boardRef = ref.child("course").child(CURRENT_YEAR).child(CURRENT_SEMESTER).child("userData").child(token).child("nofification_data")
        boardRef.observeSingleEvent(of: .value, with: { (snapshot) in
            var temp_dict = [[String:String]]()
            for snap in snapshot.children {
                let recipeSnap = snap as! DataSnapshot
                let dict = recipeSnap.value as! [String:AnyObject]
                temp_dict.append(dict as! [String : String])
            }
            temp_dict = temp_dict.reversed()
            completion(temp_dict)
        })
    }
    
    //교과목 검색 함수
    static func searchCourseDataFB(searchQuery: String, completion: @escaping ([[String:String]]) -> Void){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        var temp_dict = [[String:String]]()
        var handle: UInt = 0
        let boardRef = ref.child("course").child(CURRENT_YEAR).child(CURRENT_SEMESTER)
        handle = boardRef.child("교양").queryOrdered(byChild: "subject_nm").queryStarting(atValue: searchQuery).queryEnding(atValue: searchQuery+"\u{f8ff}").observe(_: .value, with: { (snapshot) in
            for snap in snapshot.children {
                let recipeSnap = snap as! DataSnapshot
                let dict = recipeSnap.value as! [String:AnyObject]
                temp_dict.append(dict as! [String : String])
            }
        })
        handle = boardRef.child("전공").queryOrdered(byChild: "subject_nm").queryStarting(atValue: searchQuery).queryEnding(atValue: searchQuery+"\u{f8ff}").observe(_: .value, with: { (snapshot) in
            for snap in snapshot.children {
                let recipeSnap = snap as! DataSnapshot
                let dict = recipeSnap.value as! [String:AnyObject]
                temp_dict.append(dict as! [String : String])
            }
            completion(temp_dict)
        })
        boardRef.removeObserver(withHandle: handle)
    }
    //공지사항 가져오는 함수
    static func getNoticeDataFB(completion: @escaping ([[String:String]]) -> Void){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        var temp_dict = [[String:String]]()
        var first3Notice = [[String:String]]()
        let boardRef = ref.child("course").child(CURRENT_YEAR).child(CURRENT_SEMESTER).child("notice")
        boardRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for snap in snapshot.children {
                let recipeSnap = snap as! DataSnapshot
                let dict = recipeSnap.value as! [String:AnyObject]
                temp_dict.append(dict as! [String : String])
            }
            temp_dict = temp_dict.reversed()
            var i = 0
            for dict in temp_dict{
                if i < 3 {
                    first3Notice.append(dict)
                    i += 1
                } else if i >= 3 {
                    break
                }
            }
            completion(first3Notice)
        })
    }
}
