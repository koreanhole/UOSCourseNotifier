//
//  MyCourseTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/06.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit
import QuartzCore
import AVFoundation

class MyCourseTableViewController: UITableViewController {

    
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    var zeroRemaingSeat = [[String:String]]()
    var availableCult = [[String:String]]()
    var selectableCult = [[String:String]]()
    var nessaceryCult = [[String:String]]()
    
    let cultClassification = ["교양선택", "교양필수"]
    //segment = 0 -> 내 강의, segment = 1 -> 교양, segment = 2 -> 전공
    //참고: https://stackoverflow.com/questions/26148921/switch-between-cells-when-segmentedcontrol-has-changed
    var segment = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = nil
        if !CourseData.sharedCourse.savedData.isEmpty {
            fetchingCourseData()
        }
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
            for dict in result {
                if Int(dict["remaining_seat"]!)! > 0 {
                    self.availableCult.append(dict)
                } else {
                    self.zeroRemaingSeat.append(dict)
                }
                if dict["subject_div"] == "교양선택" {
                    self.selectableCult.append(dict)
                } else if dict["subject_div"] == "교양필수" {
                    self.nessaceryCult.append(dict)
                }
            }
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
            return 3
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
            if section == 0 { return self.cultClassification.count }
            else if section == 1 { return self.availableCult.count }
            else if section == 2 { return self.zeroRemaingSeat.count }
            else { return 0 }
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
            if indexPath.section == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "cultClassification", for: indexPath) as! MyCourseTableViewCell
                cell.updateDeptListCell(with: self.cultClassification[indexPath.row])
            }
            else if indexPath.section == 1 {
                cell.updateMajorCultCell(with: self.availableCult[indexPath.row])
            } else if indexPath.section == 2 {
                cell.updateMajorCultCell(with: self.zeroRemaingSeat[indexPath.row])
            }
            
            return cell
        //전공
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "deptList", for: indexPath) as! MyCourseTableViewCell
            CourseData.saveListToFile(data: CourseData.sharedCourse.myDept_list)
            if indexPath.section == 0 {
                cell.updateDeptListCell(with: CourseData.sharedCourse.myDept_list[indexPath.row])
            } else if indexPath.section == 1 {
                cell.updateDeptListCell(with: CourseData.sharedCourse.dept_list[indexPath.row])
            }
            CourseData.saveListToFile(data: CourseData.sharedCourse.myDept_list)
            return cell
        default:
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 70))
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        switch segment {
        case 0:
            label.text = "내 강의"
            label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
            headerView.addSubview(label)
        case 1:
            if section == 0 { label.text = "구분" }
            else if section == 1 {label.text = "빈자리 과목"}
            else if section == 2 {label.text = "빈자리 없는 과목"}
            label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
            headerView.addSubview(label)
        case 2:
            if section == 0 {label.text = "즐겨찾기"}
            else if section == 1 {label.text = "전체전공"}
            label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
            headerView.addSubview(label)
        default:
            break
        }


        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch segment {
        case 0:
            return 70
        case 1:
            return 70
        case 2:
            return 70
        default:
            return 0
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
            if indexPath.section == 0 {
                self.performSegue(withIdentifier: "showCultRemainingSeat", sender: self)
                self.tableView.deselectRow(at: indexPath, animated: true)
                return
            } else {
                alert.addAction(UIAlertAction(title: "내 강의에 추가", style: .default, handler: {_ in
                    var message: String?
                    if indexPath.section == 1 {
                        CourseData.sharedCourse.savedData.append(self.availableCult[indexPath.row])
                        message = self.availableCult[indexPath.row]["subject_nm"]
                    } else if indexPath.section == 2 {
                        CourseData.sharedCourse.savedData.append(self.zeroRemaingSeat[indexPath.row])
                        message = self.zeroRemaingSeat[indexPath.row]["subject_nm"]
                    }
                    
                    let addAlert = UIAlertController(title: "내 강의에 추가하였습니다.", message: message, preferredStyle: .alert)
                    addAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.tableView.deselectRow(at: indexPath, animated: true)
                    self.present(addAlert, animated: true, completion: nil)
                }))
            }
            
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
    if segment == 0 {
        if editingStyle == .delete {
            CourseData.sharedCourse.savedData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //let indexSet = IndexSet(arrayLiteral: indexPath.section)
            //tableView.deleteSections(indexSet, with: .automatic)
            CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
        }
    } else if segment == 2 {
        if editingStyle == .delete {
            CourseData.sharedCourse.myDept_list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            CourseData.saveListToFile(data: CourseData.sharedCourse.myDept_list)
            //let indexSet = IndexSet(arrayLiteral: indexPath.section)
            //tableView.deleteSections(indexSet, with: .automatic)
        } else if editingStyle == .insert {
            let addedDept = CourseData.sharedCourse.dept_list[indexPath.row]
            //이미 즐겨찾기에 추가 되어있는 경우
            if CourseData.sharedCourse.myDept_list.contains(addedDept) {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                let alert = UIAlertController(title: "이미 즐겨찾기에 있는 학과입니다.", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
                }))
                present(alert, animated: true, completion: nil)
            //즐겨찾기에 추가 되어있지 않은 경우
            } else {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                CourseData.sharedCourse.myDept_list.append(addedDept)
                tableView.insertRows(at: [IndexPath(row: CourseData.sharedCourse.myDept_list.count-1, section: 0)], with: .automatic)

            }
        }
        CourseData.saveListToFile(data: CourseData.sharedCourse.myDept_list)
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
            if indexPath.section == 0 { return .delete }
            else { return .insert }
        default:
            return .none
        }
    }
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        if segment == 0 {
            let movedCourse = CourseData.sharedCourse.savedData.remove(at: fromIndexPath.row)
            CourseData.sharedCourse.savedData.insert(movedCourse, at: to.row)
            CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
        } else if segment == 2 {
            let movedDept = CourseData.sharedCourse.myDept_list.remove(at: fromIndexPath.row)
            CourseData.sharedCourse.myDept_list.insert(movedDept, at: to.row)
        }

        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        switch segment {
        case 0:
            return true
        case 2:
            if indexPath.section == 0 { return true }
            else { return false }
        default:
            return false
        }
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
            self.setEditing(false, animated: true)
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = self.editButton
            self.navigationItem.rightBarButtonItem?.title = "편집"
            segment = 0
        case 1:
            segment = 1
            fetchingCultData()
            self.setEditing(false, animated: true)
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
        case 2:
            segment = 2
            self.setEditing(false, animated: true)
            self.navigationItem.leftBarButtonItem = self.addButton
            self.navigationItem.rightBarButtonItem = self.editButton
            self.navigationItem.rightBarButtonItem?.title = "편집"
        default:
            break
        }
        tableView.reloadData()

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "showDetail" {
            let indexPath = tableView.indexPathForSelectedRow!
            let navController = segue.destination as! UINavigationController
            let SearchResultTableViewController = navController.topViewController as! SearchResultTableViewController
            switch segment {
            case 0:
                SearchResultTableViewController.subjectItem = CourseData.sharedCourse.savedData[indexPath.row]
            case 1:
                if indexPath.section == 1 {
                    SearchResultTableViewController.subjectItem = self.availableCult[indexPath.row]
                } else if indexPath.section == 2 {
                    SearchResultTableViewController.subjectItem = self.zeroRemaingSeat[indexPath.row]
                } else { break }
            default:
                break
            }
        } else if segue.identifier == "showDeptRemainingSeat" {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let DeptRemainingSeatTableViewController = segue.destination as! DeptRemainingSeatTableViewController
            if indexPath.section == 0 {
                DeptRemainingSeatTableViewController.deptName = CourseData.sharedCourse.myDept_list[indexPath.row]
            } else if indexPath.section == 1 {
                DeptRemainingSeatTableViewController.deptName = CourseData.sharedCourse.dept_list[indexPath.row]
            }
        } else if segue.identifier == "showCultRemainingSeat" {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let CultRemainingSeatTableViewController = segue.destination as! CultRemainingSeatTableViewController
            if indexPath.row == 0 {
                CultRemainingSeatTableViewController.cultClassification = "교양선택"
                CultRemainingSeatTableViewController.cultRemainedSeat = self.selectableCult
            } else if indexPath.row == 1 {
                CultRemainingSeatTableViewController.cultClassification = "교양필수"
                CultRemainingSeatTableViewController.cultRemainedSeat = self.nessaceryCult
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    @IBAction func unwindToSubjectTableView(segue: UIStoryboardSegue) {
        fetchingCourseData()
    }
    @IBAction func unwindWhenSearchCompleted(segue: UIStoryboardSegue) {
        self.tableView.reloadData()
    }
    @IBAction func editButtonClicked(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            self.editButton.title = "완료"
            if segment == 2 {self.navigationItem.leftBarButtonItem = nil}
            
        } else {
            self.editButton.title = "편집"
            if segment == 2 {self.navigationItem.leftBarButtonItem = self.addButton}
            
        }
    }
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
    }
}


