//
//  CourseTableViewCell.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/07.
//  Copyright © 2020 권순형. All rights reserved.
//
import UIKit


class CourseTableViewCell: UITableViewCell {

    
    @IBOutlet var subjectNameLabel: UILabel!
    @IBOutlet var professorNameLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    
    var subjectItems = [String:String]()
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.imageView?.contentMode = .scaleAspectFit
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func update (with subjectItems: [String:String]) {
        subjectNameLabel.text = subjectItems["subject_nm"]
        self.subjectItems = subjectItems
        let professor_name = subjectItems["prof_nm"]!
        let class_div = subjectItems["class_div"]! + "분반"
        if professor_name.isEmpty {
             professorNameLabel.text = "교수 미정" + " (\(class_div))"
        } else {
             professorNameLabel.text = professor_name + " (\(class_div))"
        }
}
    @IBAction func addButtonClicked(_ sender: UIButton) {
        
        var temp_result = [String:String]()
        let searchClosure = {(result: [String:String]) -> Void in
            temp_result = result
        }
        CourseData.getCourseInfoFB(subject: self.subjectItems, completion: searchClosure)
        let alert = UIAlertController(title: "내 강의에 추가", message: "\(String(describing: self.subjectItems["subject_nm"]!))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
            CourseData.saveToMyCourse(data: temp_result)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        UIApplication.shared.windows.first{$0.isKeyWindow}?.rootViewController?.present(alert, animated: true, completion: nil)        
    }
}
