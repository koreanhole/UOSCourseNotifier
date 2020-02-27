//
//  CultRemainingSeatTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/17.
//  Copyright © 2020 권순형. All rights reserved.
//


import UIKit
import Firebase

class CultRemainingSeatTableViewController: UITableViewController, GADBannerViewDelegate {
    var cultClassification = String()
    var cultRemainedSeat = [[String:String]]()
    var availableCourses = [[String:String]]()
    var unavailableCourses = [[String:String]]()
    
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
        self.navigationController?.navigationBar.topItem?.title = "교양"
        self.title = cultClassification
        for dict in cultRemainedSeat {
            //빈자리가 있는 교양의 경우
            if Int(dict["remaining_seat"]!)! > 0 {
                self.availableCourses.append(dict)
            }
            //빈자리가 없는 교양의 경우
            else {
                self.unavailableCourses.append(dict)
            }
        }
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
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return self.availableCourses.count
        case 1:
            return self.unavailableCourses.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "majorCult", for: indexPath)  as! MyCourseTableViewCell
        if indexPath.section == 0 {
            cell.updateMajorCultCell(with: self.availableCourses[indexPath.row])
        } else if indexPath.section == 1 {
            cell.updateMajorCultCell(with: self.unavailableCourses[indexPath.row])
        }
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
        //내 강의에 추가할 강의
        var addedCourse = [String:String]()
        switch indexPath.section {
        case 0:
            addedCourse = self.availableCourses[indexPath.row]
        case 1:
            addedCourse = self.unavailableCourses[indexPath.row]
        default:
            return
        }
        alert.addAction(UIAlertAction(title: "내 강의에 추가", style: .default, handler: {_ in
            CourseData.saveToMyCourse(data: addedCourse)
            let addAlert = UIAlertController(title: "내 강의에 추가하였습니다.", message: addedCourse["subject_nm"], preferredStyle: .alert)
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
            var sendingValue = [String:String]()
            if indexPath.section == 0 {
                sendingValue = self.availableCourses[indexPath.row]
            } else if indexPath.section == 1 {
                sendingValue = self.unavailableCourses[indexPath.row]
            }
            SearchResultTableViewController.subjectItem = sendingValue
        }
        //강의 계획표 보기
        else if segue.identifier == "showCoursePlan" {
            let CoursePlanTableViewController = navController.topViewController as! CoursePlanTableViewController
            var sendingValue = [String:String]()
            if indexPath.section == 0 {
                sendingValue = self.availableCourses[indexPath.row]
            } else if indexPath.section == 1 {
                sendingValue = self.unavailableCourses[indexPath.row]
            }
            CoursePlanTableViewController.subjectItem = sendingValue
        }
    }
}
