//
//  SettingsTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/18.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit
/*
 섹션 0: 알림
    row0: 알림설정
 섹션 1: 피드백 보내기
    row0: 앱스토어 리뷰남기기
    row1: 개발자에게 메일 남기기
    row2: 개발자에게 오픈카톡 보내기
 섹션 2: 라이센스
    row0: 오픈소스 라이센스
 */
class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
        }
        // #warning Incomplete implementation, return the number of rows
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //알림설정 열기
        if indexPath.section == 0 && indexPath.row == 0 {
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            if UIApplication.shared.canOpenURL(settingsUrl!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl!, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                } else {
                    UIApplication.shared.openURL(settingsUrl!)
                }
            }
            self.tableView.deselectRow(at: indexPath, animated: true)
        } else if indexPath.section == 2 && indexPath.row == 0 {
            performSegue(withIdentifier: "showOpenSourceLicense", sender: self)
        }
        //앱 리뷰 페이지
        else if indexPath.section == 1 && indexPath.row == 0 {
            rateApp()
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        //메일 보내기
        else if indexPath.section == 1 && indexPath.row == 1 {
            guard MFMailComposeViewController.canSendMail() else {
                let mailAlert = UIAlertController(title: "메일을 보낼 수 없습니다.", message: nil, preferredStyle: .alert)
                mailAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                present(mailAlert, animated: true, completion: nil)
                self.tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients(["koreanhole1@gmail.com"])
            mailComposer.setSubject("UOS수강신청 알리미 문의사항입니다.")
            
            present(mailComposer, animated: true, completion: nil)
            self.tableView.deselectRow(at: indexPath, animated: true)

        }
        //카카오톡 오픈채팅 문의하기
        else if indexPath.section == 1 && indexPath.row == 2 {
            if let url = URL(string: "https://open.kakao.com/o/sLkJmeYb") {
                UIApplication.shared.open(url, options: [:])
            }
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    //메일 작성 취소 눌렀을때 액션
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func rateApp() {
        if #available(iOS 10.3, *) {

            SKStoreReviewController.requestReview()

        } else {

            let appID = "1499590559"
            //let urlStr = "https://itunes.apple.com/app/id\(appID)" // (Option 1) Open App Page
            let urlStr = "https://itunes.apple.com/app/id\(appID)?action=write-review" // (Option 2) Open App Review Page

            guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url) // openURL(_:) is deprecated from iOS 10.
            }
        }
    }
}
