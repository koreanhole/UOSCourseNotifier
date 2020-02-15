//
//  MyCourseTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/06.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit
import QuartzCore

class MyCourseTableViewController: UITableViewController {
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    //segment = 0 -> 내 강의, segment = 1 -> 교양, segment = 2 -> 전공
    //참고: https://stackoverflow.com/questions/26148921/switch-between-cells-when-segmentedcontrol-has-changed
    var segment = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
        if !CourseData.loadFromFile().isEmpty {
            CourseData.sharedCourse.savedData = CourseData.loadFromFile()
        }
        fetchingCourseData()
        //self.tableView.allowsSelection = true

    }
    func fetchingCourseData() {
        self.refreshControl?.beginRefreshing()
        for index in 0..<CourseData.sharedCourse.savedData.count {
            let searchClosure = {(result: [String:String]) -> Void in
                CourseData.sharedCourse.savedData[index] = result
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
            CourseData.getCourseInfoFB(subject: CourseData.sharedCourse.savedData[index], completion: searchClosure)
        }
    }
    
    func fetchingCultData() {
        self.refreshControl?.beginRefreshing()
        let searchClosure = {(result: [[String:String]]) -> Void in
            CourseData.sharedCourse.cultData = result
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        CourseData.getCultInfoFB(completion: searchClosure)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        switch segment {
        //내강의
        case 0:
            return 1
        //교양
        case 1:
            return 1
        //전공
        case 2:
            return 2
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch segment {
        //내강의
        case 0:
            return CourseData.sharedCourse.savedData.count
        //교양
        case 1:
            return CourseData.sharedCourse.cultData.count
        //전공
        case 2:
            switch section {
            case 0:
                return CourseData.sharedCourse.myDept_list.count
            case 1:
                return CourseData.sharedCourse.dept_list.count
            default:
                return 0
            }
        default:
            return 0
        }
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = MyCourseTableViewCell()

        switch segment {
        //내강의
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "majorCult", for: indexPath) as! MyCourseTableViewCell
            CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
            cell.updateMajorCultCell(with: CourseData.sharedCourse.savedData[indexPath.row])
            //cell.updateMyCourseCell(with: CourseData.sharedCourse.savedData[indexPath.section])
            return cell
        //교양
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "majorCult", for: indexPath) as! MyCourseTableViewCell
            cell.updateMajorCultCell(with: CourseData.sharedCourse.cultData[indexPath.row])
            return cell
        //전공
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "deptList", for: indexPath) as! MyCourseTableViewCell
            if indexPath.section == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "myDeptList", for: indexPath) as! MyCourseTableViewCell
                cell.updateDeptListCell(with: CourseData.sharedCourse.myDept_list[indexPath.row])
                cell.favoritButton.isHidden = true
            } else if indexPath.section == 1 {
                cell = tableView.dequeueReusableCell(withIdentifier: "deptList", for: indexPath) as! MyCourseTableViewCell
                cell.updateDeptListCell(with: CourseData.sharedCourse.dept_list[indexPath.row])
            }
            if CourseData.sharedCourse.myDept_list.contains(CourseData.sharedCourse.dept_list[indexPath.row]) {
                cell.favoritButton.setImage(UIImage(systemName: "star"), for: .normal)
                cell.favoritButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
                cell.favoritButton.isSelected = true
            } else {
                cell.favoritButton.setImage(UIImage(systemName: "star"), for: .normal)
                cell.favoritButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
                cell.favoritButton.isSelected = false
            }
            return cell
        default:
            return cell
        }
    }

    

    @objc func refresh(sender:AnyObject){
        // Updating your data here...
        switch segment {
        case 0:
            fetchingCourseData()
            CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
        case 1:
            fetchingCultData()
        case 2:
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        default:
            return
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "수강신청 어플로 가기", style: .default, handler: {_ in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "강의계획표", style: .default, handler: {_ in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "상세정보", style: .default, handler: {_ in
            self.performSegue(withIdentifier: "showDetail", sender: self)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        switch segment {
        case 0:
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: {_ in
                let deleteAlert = UIAlertController(title: "정말 삭제하시겠습니까?", message: CourseData.sharedCourse.savedData[indexPath.row]["subject_nm"], preferredStyle: .alert)
                deleteAlert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: {_ in
                    CourseData.sharedCourse.savedData.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    //let indexSet = IndexSet(arrayLiteral: indexPath.row)
                    //tableView.deleteSections(indexSet, with: .automatic)
                    CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
                }))
                deleteAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                self.present(deleteAlert, animated: true, completion: nil)
            }))
        case 1:
            alert.addAction(UIAlertAction(title: "내 강의에 추가", style: .default, handler: {_ in
                CourseData.sharedCourse.savedData.append(CourseData.sharedCourse.cultData[indexPath.row])
                let addAlert = UIAlertController(title: "내 강의에 추가하였습니다.", message: CourseData.sharedCourse.cultData[indexPath.row]["subject_nm"], preferredStyle: .alert)
                addAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.present(addAlert, animated: true, completion: nil)
            }))
        case 2:
            self.performSegue(withIdentifier: "showDeptRemainingSeat", sender: self)
            self.tableView.deselectRow(at: indexPath, animated: true)
            return
        default:
            return
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: {_ in
            self.tableView.deselectRow(at: indexPath, animated: true)
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

    
    // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CourseData.sharedCourse.savedData.remove(at: indexPath.section)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //let indexSet = IndexSet(arrayLiteral: indexPath.section)
            //tableView.deleteSections(indexSet, with: .automatic)
            CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch segment {
        //내강의
        case 0:
            return .delete
        //교양
        case 1:
            return .none
        //전공
        case 2:
            return .delete
        default:
            return .none
        }
    }
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedCourse = CourseData.sharedCourse.savedData.remove(at: fromIndexPath.row)
        CourseData.sharedCourse.savedData.insert(movedCourse, at: to.row)
        CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
        tableView.reloadData()
    }
    

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
    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.navigationItem.rightBarButtonItem = self.editButton
            self.navigationItem.rightBarButtonItem?.title = "편집"
            segment = 0
        case 1:
            segment = 1
            fetchingCultData()
            self.setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem = nil
        case 2:
            segment = 2
            self.setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem = nil
        default:
            break
        }
        tableView.reloadData()

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow!
        let navController = segue.destination as! UINavigationController
        
        if segue.identifier == "showDetail" {
            let SearchResultTableViewController = navController.topViewController as! SearchResultTableViewController
            switch segment {
            case 0:
                SearchResultTableViewController.subjectItem = CourseData.sharedCourse.savedData[indexPath.row]
            case 1:
                SearchResultTableViewController.subjectItem = CourseData.sharedCourse.cultData[indexPath.row]
            default:
                break
            }
        } else if segue.identifier == "showDeptRemainingSeat" {
            let DeptRemainingSeatTableViewController = navController.topViewController as! DeptRemainingSeatTableViewController
            if indexPath.section == 0 {
                DeptRemainingSeatTableViewController.deptName = CourseData.sharedCourse.myDept_list[indexPath.row]
            } else if indexPath.section == 1 {
                DeptRemainingSeatTableViewController.deptName = CourseData.sharedCourse.dept_list[indexPath.row]
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    @IBAction func unwindToSubjectTableView(segue: UIStoryboardSegue) {
        fetchingCourseData()
    }
    @IBAction func editButtonClicked(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)

        if tableView.isEditing {
            self.editButton.title = "완료"
        } else {
            self.editButton.title = "편집"
        }
    }
}

