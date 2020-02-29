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
    
    //빈자리가 없는 교양목록
    var zeroRemaingSeat = [[String:String]]()
    //빈자리 있는 교양목록
    var availableCult = [[String:String]]()
    //교양선택 과목
    var selectableCult = [[String:String]]()
    //교양필수 과목
    var nessaceryCult = [[String:String]]()
    
    let cultClassification = ["교양선택", "교양필수"]
    //segment = 0 -> 내 강의, segment = 1 -> 교양, segment = 2 -> 전공
    //참고: https://stackoverflow.com/questions/26148921/switch-between-cells-when-segmentedcontrol-has-changed
    var segment = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.navigationItem.leftBarButtonItem = nil
        //디바이스에 내 강의가 저장되어 있다면 이를 새로고침
        if !CourseData.sharedCourse.savedData.isEmpty {
            fetchingCourseData()
        }
        showUpdateAlert(updateMessage: "검색기능이 향상되었습니다.\n(학교API에 접근불가능 할때도 강의를 검색할 수 있습니다.)")
    }
    func showUpdateAlert(updateMessage: String) {
        let currentVersion = Bundle.main.object(forInfoDictionaryKey:     "CFBundleShortVersionString") as? String
        let versionOfLastRun = UserDefaults.standard.object(forKey: "VersionOfLastRun") as? String
        //앱이 새로 설치 되었거나 업데이트 되었을때 알림창 띄움
        if versionOfLastRun == nil  || versionOfLastRun != currentVersion  {
            let updateAlert = UIAlertController(title: "[Ver\(currentVersion!)] 업데이트 내역", message: updateMessage, preferredStyle: .alert)
            updateAlert.addAction((UIAlertAction(title: "확인", style: .default, handler: nil)))
            self.present(updateAlert, animated: true, completion: nil)
        }

        UserDefaults.standard.set(currentVersion, forKey: "VersionOfLastRun")
        UserDefaults.standard.synchronize()
    }
    //내 강의 목록을 새로고침하는 함수
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
    
    //교양 강의를 새로고침하는 함수
    func fetchingCultData() {
        self.refreshControl?.beginRefreshing()
        let searchClosure = {(result: [[String:String]]) -> Void in
            for dict in result {
                //빈자리가 있는 경우
                if Int(dict["remaining_seat"]!)! > 0 {
                    self.availableCult.append(dict)
                }
                //빈자리가 없는 경우
                else {
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


    override func numberOfSections(in tableView: UITableView) -> Int {
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
            return cell
        //교양
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "majorCult", for: indexPath) as! MyCourseTableViewCell
            //교양선택, 교양필수 셀
            if indexPath.section == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "cultClassification", for: indexPath) as! MyCourseTableViewCell
                cell.updateDeptListCell(with: self.cultClassification[indexPath.row])
            }
            //빈자리 있는 교양 업데이트
            else if indexPath.section == 1 {
                cell.updateMajorCultCell(with: self.availableCult[indexPath.row])
            }
            //빈자리 없는 교양 업데이트
            else if indexPath.section == 2 {
                cell.updateMajorCultCell(with: self.zeroRemaingSeat[indexPath.row])
            }
            
            return cell
        //전공
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "deptList", for: indexPath) as! MyCourseTableViewCell
            CourseData.saveListToFile(data: CourseData.sharedCourse.myDept_list)
            //첫번쨰 섹션에는 내가 저장한 학과 목록 보여줌
            if indexPath.section == 0 {
                cell.updateDeptListCell(with: CourseData.sharedCourse.myDept_list[indexPath.row])
            }
            //두번째 섹션에는 전체 학과 보여줌
            else if indexPath.section == 1 {
                cell.updateDeptListCell(with: CourseData.sharedCourse.dept_list[indexPath.row])
            }
            CourseData.saveListToFile(data: CourseData.sharedCourse.myDept_list)
            return cell
        default:
            return cell
        }
    }
    
    //각 섹션의 헤더설정
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
    //각 섹션별 높이 지정
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
        //각 섹션별 당겨서 새로고침하면 실행되는 내용
        case 0:
            if !CourseData.sharedCourse.savedData.isEmpty {
                fetchingCourseData()
                CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
            } else {
                self.refreshControl?.endRefreshing()
            }
            
        case 1:
            fetchingCultData()
        case 2:
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        default:
            return
        }
    }

    //셀을 탭할 경우 실행되는 내용
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "강의계획표", style: .default, handler: {_ in
            //강의 계획표를 선택할 경우 강의 계획표를 보여주는 segue실행
            self.performSegue(withIdentifier: "showCoursePlan", sender: self)
            self.tableView.deselectRow(at: indexPath, animated: true)
            return
        }))
        alert.addAction(UIAlertAction(title: "상세정보", style: .default, handler: {_ in
            //상세정보를 선택할 경우 상세정보를 보여주는 segue실행
            self.performSegue(withIdentifier: "showDetail", sender: self)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        switch segment {
        //내 강의 섹션에서는 삭제 할 수 있는 옵션을 제공한다.
        case 0:
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: {_ in
                let deleteAlert = UIAlertController(title: "정말 삭제하시겠습니까?", message: CourseData.sharedCourse.savedData[indexPath.row]["subject_nm"], preferredStyle: .alert)
                deleteAlert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: {_ in
                    //삭제에 대해 다시한번 확인 한 후 삭제를 진행한다.
                    CourseData.deleteMyCourse(from: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }))
                deleteAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: {_ in
                    //사용자가 취소를 누른 경우 삭제를 하지 않고 셀에 대한 선택을 취소한다.
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }))
                self.present(deleteAlert, animated: true, completion: nil)
            }))
        //교양 목록에 대해서 셀을 선택했을 때 실행되는 내용
        case 1:
            //첫번째 섹션일 경우는 각 셀에 해당하는 목록(새로운 테이블 뷰)를 보여주기만 한다.
            if indexPath.section == 0 {
                self.performSegue(withIdentifier: "showCultRemainingSeat", sender: self)
                self.tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            //두번째 섹션일 경우 내강의에 추가 옵션을 보여준다.
            else {
                alert.addAction(UIAlertAction(title: "내 강의에 추가", style: .default, handler: {_ in
                    var message: String?
                    //빈자리가 있는 강의를 선택할 경우
                    if indexPath.section == 1 {
                        CourseData.saveToMyCourse(data: self.availableCult[indexPath.row])
                        message = self.availableCult[indexPath.row]["subject_nm"]
                    }
                    //빈자리가 없는 강의를 선택했을 경우
                    else if indexPath.section == 2 {
                        CourseData.saveToMyCourse(data: self.zeroRemaingSeat[indexPath.row])
                        message = self.zeroRemaingSeat[indexPath.row]["subject_nm"]
                    }
                    //유저에게 따로 확인창은 띄우지 않고 그냥 추가한다.
                    let addAlert = UIAlertController(title: "내 강의에 추가하였습니다.", message: message, preferredStyle: .alert)
                    addAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.tableView.deselectRow(at: indexPath, animated: true)
                    self.present(addAlert, animated: true, completion: nil)
                }))
            }
        //전공 섹션의 경우는 부서별 남은 자리를 보여주는 테이블 뷰를 표시해준다.
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

    
    // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //내 강의 섹션은 삭제 옵션만 추가한다.
        if segment == 0 {
            if editingStyle == .delete {
                CourseData.deleteMyCourse(from: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        //전공 섹션은 삭제와 추가 옵션만 추가한다.
        else if segment == 2 {
            //삭제할 경우
            if editingStyle == .delete {
                CourseData.sharedCourse.myDept_list.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                CourseData.saveListToFile(data: CourseData.sharedCourse.myDept_list)
            }
            //추가할 경우
            else if editingStyle == .insert {
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
        //내강의는 삭제만
        case 0:
            return .delete
        //교양
        case 1:
            return .none
        //전공탭의 첫번째 섹션은 삭제만, 두번째 섹션은 삽입만 가능하게 함
        case 2:
            if indexPath.section == 0 { return .delete }
            else { return .insert }
        default:
            return .none
        }
    }
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        //내 강의 목록 순서 변경
        if segment == 0 {
            let movedCourse = CourseData.sharedCourse.savedData.remove(at: fromIndexPath.row)
            CourseData.sharedCourse.savedData.insert(movedCourse, at: to.row)
            CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
        }
        //학과 목록 순서 변경
        else if segment == 2 {
            let movedDept = CourseData.sharedCourse.myDept_list.remove(at: fromIndexPath.row)
            CourseData.sharedCourse.myDept_list.insert(movedDept, at: to.row)
        }
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        switch segment {
        //내 강의는 순서 변경 허용
        case 0:
            return true
        //전공탭은 저장한 학과 목록만 순서 변경 허용
        case 2:
            if indexPath.section == 0 { return true }
            else { return false }
        default:
            return false
        }
    }

    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        //내강의 화면으로 탭이 변경 되었을 경우
        case 0:
            self.setEditing(false, animated: true)
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = self.editButton
            self.navigationItem.rightBarButtonItem?.title = "편집"
            segment = 0
        //교양 탭으로 변경되었을 경우
        case 1:
            segment = 1
            fetchingCultData()
            self.setEditing(false, animated: true)
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
        //전공탭으로 변경되었을 경우
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

        //강의 상세정보를 보여주는 segue
        if segue.identifier == "showDetail" {
            let indexPath = tableView.indexPathForSelectedRow!
            let navController = segue.destination as! UINavigationController
            let SearchResultTableViewController = navController.topViewController as! SearchResultTableViewController
            switch segment {
            //탭 별 segue의 destination에 전달해주는 데이터
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
        }
        //학과별 남은 자리를 보여주는 segue
        else if segue.identifier == "showDeptRemainingSeat" {
            let indexPath = tableView.indexPathForSelectedRow!
            let DeptRemainingSeatTableViewController = segue.destination as! DeptRemainingSeatTableViewController
            //저장된 학과일 경우
            if indexPath.section == 0 {
                DeptRemainingSeatTableViewController.deptName = CourseData.sharedCourse.myDept_list[indexPath.row]
            }
            //저장되지 않은 학과일 경우
            else if indexPath.section == 1 {
                DeptRemainingSeatTableViewController.deptName = CourseData.sharedCourse.dept_list[indexPath.row]
            }
        }
        //교양과목의 빈자리를 보여주는 segue
        else if segue.identifier == "showCultRemainingSeat" {
            let indexPath = tableView.indexPathForSelectedRow!
            let CultRemainingSeatTableViewController = segue.destination as! CultRemainingSeatTableViewController
            //교양선택을 눌렀을 경우
            if indexPath.row == 0 {
                CultRemainingSeatTableViewController.cultClassification = "교양선택"
                CultRemainingSeatTableViewController.cultRemainedSeat = self.selectableCult
            }
            //교양 필수인 경우
            else if indexPath.row == 1 {
                CultRemainingSeatTableViewController.cultClassification = "교양필수"
                CultRemainingSeatTableViewController.cultRemainedSeat = self.nessaceryCult
            }
        }
        //강의 계획표를 보여주는 segue
        else if segue.identifier == "showCoursePlan" {
            let indexPath = tableView.indexPathForSelectedRow!
            let navController = segue.destination as! UINavigationController
            let CoursePlanTableViewController = navController.topViewController as! CoursePlanTableViewController
            switch segment {
            case 0:
                CoursePlanTableViewController.subjectItem = CourseData.sharedCourse.savedData[indexPath.row]
            case 1:
                if indexPath.section == 1 {
                    CoursePlanTableViewController.subjectItem = self.availableCult[indexPath.row]
                } else if indexPath.section == 2 {
                    CoursePlanTableViewController.subjectItem = self.zeroRemaingSeat[indexPath.row]
                } else { break }
            default:
                break
            }
        }
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
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "deptAdded" else {
            return
        }
        tableView.reloadData()
    }
}


