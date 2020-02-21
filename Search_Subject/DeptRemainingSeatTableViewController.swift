//
//  DeptRemainingSeatTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/15.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit

class DeptRemainingSeatTableViewController: UITableViewController {
    
    var deptName = String()
    var remainedSeat = [[String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = deptName
        fetchingMajorData()
        
        //backbutton 텍스트 수정
        self.navigationController?.navigationBar.topItem?.title = "전공"


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    @objc func refresh(sender:AnyObject){
        // Updating your data here...
        fetchingMajorData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CourseData.sharedCourse.majorData.count
    }
    func fetchingMajorData() {
        self.refreshControl?.beginRefreshing()
        let searchClosure = {(result: [[String:String]]) -> Void in
            CourseData.sharedCourse.majorData = result
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        CourseData.getMajorInfoFB(deptName: self.deptName, completion: searchClosure)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "majorCult", for: indexPath)  as! MyCourseTableViewCell
        cell.updateMajorCultCell(with: CourseData.sharedCourse.majorData[indexPath.row])
        /*cell.favoritButton.setImage(UIImage(systemName: "star"), for: .normal)
        cell.favoritButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        cell.favoritButton.isSelected = false
 */
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "강의계획표", style: .default, handler: {_ in
            self.performSegue(withIdentifier: "showCoursePlan", sender: self)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "상세정보", style: .default, handler: {_ in
            self.performSegue(withIdentifier: "showDetail", sender: self)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: {_ in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "내 강의에 추가", style: .default, handler: {_ in
            CourseData.saveToMyCourse(data: CourseData.sharedCourse.majorData[indexPath.row])
            //CourseData.sharedCourse.savedData.append(CourseData.sharedCourse.majorData[indexPath.row])
            let addAlert = UIAlertController(title: "내 강의에 추가하였습니다.", message: CourseData.sharedCourse.majorData[indexPath.row]["subject_nm"], preferredStyle: .alert)
            addAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.present(addAlert, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow!
        let navController = segue.destination as! UINavigationController
        
        if segue.identifier == "showDetail" {
            let SearchResultTableViewController = navController.topViewController as! SearchResultTableViewController
            SearchResultTableViewController.subjectItem = CourseData.sharedCourse.majorData[indexPath.row]
        } else if segue.identifier == "showCoursePlan" {
            let CoursePlanTableViewController = navController.topViewController as! CoursePlanTableViewController
            CoursePlanTableViewController.subjectItem = CourseData.sharedCourse.majorData[indexPath.row]
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    @IBAction func unwindToSubjectTableView(segue: UIStoryboardSegue) {
    }

}
