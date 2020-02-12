//
//  MyCourseTableViewCell.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/07.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit

class MyCourseTableViewCell: UITableViewCell {

    @IBOutlet var subjectNameLabel: UILabel!
    @IBOutlet var professorNameLabel: UILabel!
    @IBOutlet var remainingSeatLabel: UILabel!
    
    @IBOutlet var majoCultSubjectNameLabel: UILabel!
    @IBOutlet var majorCultProfessorNameLabel: UILabel!
    @IBOutlet var majorCultRemainingSeatLabel: UILabel!
    
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
        professorNameLabel.text = professor_name + "(\(class_div)분반)"
        if remainingSeat.isEmpty || Int(remainingSeat) == 0 {
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
        majorCultProfessorNameLabel.text = professor_name + "(\(class_div)분반)"
        if remainingSeat.isEmpty || Int(remainingSeat) == 0 {
            majorCultRemainingSeatLabel.text = "남은자리: 0명"
            majoCultSubjectNameLabel.textColor = UIColor.systemRed
        } else {
            majorCultRemainingSeatLabel.text = "남은자리: \(remainingSeat)명"
            majoCultSubjectNameLabel.textColor = UIColor.systemBlue
        }
    }
    

}
