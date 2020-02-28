//
//  SearchResultTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/06.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit
import Firebase

class SearchResultTableViewController: UITableViewController, GADBannerViewDelegate {
    @IBOutlet weak var prof_nm: UILabel!
    @IBOutlet weak var subject_div: UILabel!
    @IBOutlet weak var class_div: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var dept: UILabel!
    @IBOutlet var shyr: UILabel!
    @IBOutlet var tlsn_count: UILabel!
    @IBOutlet var tlsn_limit_count: UILabel!
    @IBOutlet var remainingSeat: UILabel!
    @IBOutlet var sec_permit_yn: UILabel!
    @IBOutlet var etc_permit_yn: UILabel!
    @IBOutlet var class_nm: UILabel!
    
    var subjectItem = [String:String]()
    
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
        self.title = subjectItem["subject_nm"]
        self.prof_nm.text = subjectItem["prof_nm"]
        self.subject_div.text = subjectItem["subject_div"]
        self.class_div.text = subjectItem["class_div"] ?? String()+"분반"
        self.credit.text = subjectItem["credit"] ?? String()+"학점"
        self.dept.text = subjectItem["sub_dept"]
        self.shyr.text = subjectItem["shyr"] ?? String()+"학년"
        if subjectItem["tlsn_count"]?.isEmpty ?? true {
            self.tlsn_count.text = "0명"
        } else {
            self.tlsn_count.text = subjectItem["tlsn_count"]!+"명"
        }
        if subjectItem["tlsn_limit_count"]?.isEmpty ?? true  {
            self.tlsn_limit_count.text = "0명"
        } else {
            self.tlsn_limit_count.text = subjectItem["tlsn_limit_count"]!+"명"
        }
        if subjectItem["remaining_seat"]?.isEmpty ?? true {
            self.remainingSeat.text = "0명"
        } else {
            self.remainingSeat.text = subjectItem["remaining_seat"]!+"명"
        }
        self.sec_permit_yn.text = subjectItem["sec_permit_yn"]
        self.etc_permit_yn.text = subjectItem["etc_permit_yn"]
        self.class_nm.text = subjectItem["class_nm"]

        //광고 게시
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    @IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
