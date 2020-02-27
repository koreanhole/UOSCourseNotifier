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
        print("Banner loaded successfully")
        tableView.tableHeaderView?.frame = bannerView.frame
        tableView.tableHeaderView = bannerView
        
    }
     
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
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

}
