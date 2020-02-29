//
//  CoursePlanTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/20.
//  Copyright © 2020 권순형. All rights reserved.
//  강의 계획표를 보여주는 화면

import UIKit
import Firebase


class CoursePlanTableViewController: UITableViewController, GADBannerViewDelegate {
    
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
        (self.coursePlan, self.courseWeeklyPlan) = requestCoursePlan(subjectNo: subjectItem["subject_no"]!, classDiv: subjectItem["class_div"]!)
        
        //강의 계획표 로딩 실패할 경우 경고창 표시
        if self.coursePlan.isEmpty {
            self.title = ""
            let emptyAlert = UIAlertController(title: "강의계획표를 불러올 수 없습니다.", message: nil, preferredStyle: .alert)
            emptyAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
                //테스트 위해 주석처리
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(emptyAlert, animated: true, completion: nil)
        } else {
            //강의 계획표 로딩이 성공한 경우
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
        
        //광고 게시
        //광고게시는 일단 비활성화
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


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeeklyPlan" {
            let navController = segue.destination as! UITableViewController
            let WeeklyCourseTableViewController = navController as! WeeklyCourseTableViewController
            WeeklyCourseTableViewController.courseWeeklyPlan = self.courseWeeklyPlan
        }
    }
    @IBAction func getWeeklyPlanButtonClicked(_ sender: UIButton) {
    }
    @IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
