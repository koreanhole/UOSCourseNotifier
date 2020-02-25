//
//  SearchDeptTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/16.
//  Copyright © 2020 권순형. All rights reserved.
//  학과 검색하는 tableView

import UIKit

class SearchDeptTableViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchResult = CourseData.sharedCourse.dept_list
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.placeholder = "검색"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResult.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchedDept", for: indexPath)
        cell.textLabel?.text = searchResult[indexPath.row]


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        //이미 즐겨찾기에 추가되어있을때
        if CourseData.sharedCourse.myDept_list.contains(searchResult[indexPath.row]) {
            alert.title = "이미 즐겨찾기에 추가되어 있습니다."
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        }
        //즐겨찾기에 없을때
        else {
            alert.title = "즐겨찾기에 추가하였습니다."
            alert.message = searchResult[indexPath.row]
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
                CourseData.sharedCourse.myDept_list.append(self.searchResult[indexPath.row])
                self.performSegue(withIdentifier: "searchCompleted", sender: self)
            }))
        }
        present(alert, animated: true, completion: nil)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    //사용자가 입력한 데이터가 변할때마다 그에 대한 검색결과를 화면에 보여준다.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //사용자가 입력한 값의 앞부분이 맞는것을 보여준다.
        searchResult = CourseData.sharedCourse.dept_list.filter({$0.prefix(searchText.count) == searchText})
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResult = CourseData.sharedCourse.dept_list
        self.tableView.reloadData()
    }
    @IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
