//
//  CoursePlanTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/20.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit

class CoursePlanTableViewController: UITableViewController {
    
    var subjectItem = [String:String]()
    
    //xmlparser extension에서 쓰는 데이터들
    var xmlParser = XMLParser()
    var currentElement = String()
    
    var coursePlanItem: [String:String] = ["subject_no" : "", "subject_nm" : "", "prof_nm" : "", "tel_no" : "", "score_eval_rate" : "", "book_nm" : "", "lec_goal_descr" : "", "curi_edu_goal_nm" : "", "week" : "", "class_cont" : "", "class_meth" : "", "week_book" : "", "prjt_etc" : ""]
    var coursePlanItems = [[String:String]]()

    
    //cell labels
    @IBOutlet var subject_no: UILabel!
    @IBOutlet var subject_nm: UILabel!
    @IBOutlet var prof_nm: UILabel!
    @IBOutlet var tel_no: UILabel!
    @IBOutlet var score_eval_rate: UILabel!
    @IBOutlet var book_nm: UILabel!
    @IBOutlet var lec_goal_descr: UILabel!
    @IBOutlet var curi_edu_goal_nm: UILabel!
    @IBOutlet var get_weeklyPlan_Button: UIButton!
    
    
    //함수 결과값
    var coursePlan = [String:String]()
    var courseWeeklyPlan = [[String:String]]()
        

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "강의 계획표 없음"
        (self.coursePlan, self.courseWeeklyPlan) = requestCoursePlan(subjectNo: subjectItem["subject_no"]!, classDiv: subjectItem["class_div"]!)
        self.title = self.coursePlan["subject_nm"]
        self.subject_no.text = self.coursePlan["subject_no"]
        self.subject_nm.text = self.coursePlan["subject_nm"]
        self.prof_nm.text = self.coursePlan["prof_nm"]
        self.tel_no.text = self.coursePlan["tel_no"]
        self.score_eval_rate.text = self.coursePlan["score_eval_rate"]
        self.book_nm.text = self.coursePlan["book_nm"]
        self.lec_goal_descr.text = self.coursePlan["lec_goal_descr"]
        self.curi_edu_goal_nm.text = self.coursePlan["curi_edu_goal_nm"]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeeklyPlan" {
            let navController = segue.destination as! UITableViewController
            let WeeklyCourseTableViewController = navController as! WeeklyCourseTableViewController
            WeeklyCourseTableViewController.courseWeeklyPlan = self.courseWeeklyPlan
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    @IBAction func getWeeklyPlanButtonClicked(_ sender: UIButton) {
    }
    @IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
