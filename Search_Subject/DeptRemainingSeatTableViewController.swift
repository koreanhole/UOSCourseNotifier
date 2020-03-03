//
//  DeptRemainingSeatTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/15.
//  Copyright © 2020 권순형. All rights reserved.
//  전공별 빈자리 보여주는 화면

import UIKit
import Firebase

class DeptRemainingSeatTableViewController: UITableViewController, GADBannerViewDelegate {
    
    var deptName = String()
    var remainedSeat = [[String:String]]()
    
    //admob변수
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = AdmobData.adUnitID
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = deptName
        fetchingMajorData()
        
        self.navigationController?.navigationBar.topItem?.title = "전공"
        
        adBannerView.load(GADRequest())

    }
    //admob설정
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        tableView.tableHeaderView?.frame = bannerView.frame
        tableView.tableHeaderView = bannerView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    @objc func refresh(sender:AnyObject){
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
        //학과별 빈자리데이터 불러오기가 완료되었을 경우 테이블뷰를 새로고침해준다.
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow!
        let navController = segue.destination as! UINavigationController
        
        //강의 상세정보 보기
        if segue.identifier == "showDetail" {
            let SearchResultTableViewController = navController.topViewController as! SearchResultTableViewController
            SearchResultTableViewController.subjectItem = CourseData.sharedCourse.majorData[indexPath.row]
        }
        //강의계획표 보기
        else if segue.identifier == "showCoursePlan" {
            let CoursePlanTableViewController = navController.topViewController as! CoursePlanTableViewController
            CoursePlanTableViewController.subjectItem = CourseData.sharedCourse.majorData[indexPath.row]
        }
    }
    /*
    var dept_list = ["건축공학과", "건축학과", "경영학과", "경영학과(EMBA)", "경영학부", "경제학과", "경제학부", "공간정보공학과", "공과대학(학과)", "교통공학과", "교통관리학과", "국사학과", "국어국문학과", "국제관계학과", "국제교육원(학사-과)", "국제도시개발프로그램", "글로벌건설학과", "기계공학과", "기계정보공학과", "도시계획학과", "도시공학과", "도시사회학과", "도시행정학과", "문화예술관광학과", "물리학과", "방재공학과", "법학과", "법학과(LLM)", "법학전문대학원", "부동산학과", "사회복지학과", "산업디자인학과", "생명과학과", "세무학과", "소방방재학과", "수학과", "수학교육전공", "스포츠과학과", "신소재공학과", "역사교육전공", "영어교육전공", "영어영문학과", "음악학과", "재난과학과", "전자전기컴퓨터공학과", "전자전기컴퓨터공학부", "조경학과", "중국어문화학과", "철학과", "첨단녹색도시개발학과", "컴퓨터과학과", "컴퓨터과학부", "토목공학과", "통계학과", "행정학과", "행정학과(EMPA)", "화학공학과", "환경공학과", "환경공학부", "환경원예학과", "환경조각학과"]
 */
    func connectTo(deptName: String) {
    }

}
