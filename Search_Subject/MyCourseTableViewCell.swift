//
//  MyCourseTableViewCell.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/07.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit
import AVFoundation

class MyCourseTableViewCell: UITableViewCell {

    @IBOutlet var subjectNameLabel: UILabel!
    @IBOutlet var professorNameLabel: UILabel!
    @IBOutlet var remainingSeatLabel: UILabel!
    
    @IBOutlet var majoCultSubjectNameLabel: UILabel!
    @IBOutlet var majorCultProfessorNameLabel: UILabel!
    @IBOutlet var majorCultRemainingSeatLabel: UILabel!
    
    @IBOutlet var favoritButton: UIButton!
    @IBOutlet var deptList_nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateMyCourseCell (with courseInfo: [String:String]) {
        let subject_name = courseInfo["subject_nm"]
        let professor_name = courseInfo["prof_nm"] ?? ""
        let class_div = courseInfo["class_div"] ?? ""
        let remainingSeat = courseInfo["remaining_seat"] ?? ""
        subjectNameLabel.text = subject_name
        if professor_name == "" {
             professorNameLabel.text = "교수 미정" + " (\(class_div))"
        } else {
             professorNameLabel.text = professor_name + " (\(class_div))"
        }
        if remainingSeat.isEmpty || Int(remainingSeat)! < 0 {
            remainingSeatLabel.text = "남은자리: 0명"
            subjectNameLabel.textColor = UIColor.systemRed
        } else {
            remainingSeatLabel.text = "남은자리: \(remainingSeat)명"
            subjectNameLabel.textColor = UIColor.systemBlue
        }
    }
    func updateMajorCultCell (with courseInfo: [String:String]) {
        let subject_name = courseInfo["subject_nm"]
        let professor_name = courseInfo["prof_nm"] ?? ""
        let class_div = courseInfo["class_div"] ?? ""
        let remainingSeat = courseInfo["remaining_seat"] ?? ""
        majoCultSubjectNameLabel.text = subject_name
        if professor_name == "" {
             majorCultProfessorNameLabel.text = "교수 미정" + " (\(class_div))"
        } else {
             majorCultProfessorNameLabel.text = professor_name + " (\(class_div))"
        }
        if remainingSeat.isEmpty || Int(remainingSeat) == 0 {
            majorCultRemainingSeatLabel.text = "남은자리: 0명"
            majoCultSubjectNameLabel.textColor = UIColor.systemRed
        } else {
            majorCultRemainingSeatLabel.text = "남은자리: \(remainingSeat)명"
            majoCultSubjectNameLabel.textColor = UIColor.systemBlue
        }
    }
    func updateDeptListCell (with deptName: String) {
        deptList_nameLabel.text = deptName
    }
    @IBAction func favoriteButtonClicked(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        //저장된 학과에서 제거
        if (sender.isSelected){
            sender.isSelected = false
            let index = CourseData.sharedCourse.myDept_list.firstIndex(of: self.deptList_nameLabel.text!)!
            CourseData.sharedCourse.myDept_list.remove(at: index)
         }
        // 저장된 학과에 추가
        else {
            sender.isSelected = true
            CourseData.sharedCourse.myDept_list.append(self.deptList_nameLabel.text!)
        }
        CourseData.sharedCourse.myDept_list = CourseData.sharedCourse.myDept_list.dropDuplicates()
    }
}
