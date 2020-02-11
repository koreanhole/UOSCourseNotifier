//
//  SearchSubject.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/10.
//  Copyright © 2020 권순형. All rights reserved.
//

import Foundation


extension SubjectTableViewController: XMLParserDelegate {
    
    
    func requestSubjectInfo(searchTerm: String){
        subjectItems = [[String:String]]()
        let query: [String: String] = [
            "apiKey": "202001610WYX35223",
            "year": "2020",
            "term": "A10",
            "subjectNm": searchTerm
        ]
        let baseURL = URL(string: "https://wise.uos.ac.kr/uosdoc/api.ApiApiSubjectList.oapi?")!
        
        guard let url = baseURL.withQueries(query) else {
            
            print("Unable to build URL with supplied queries.")
            return
        }
        guard let xmlParser = XMLParser(contentsOf: url) else { return }
        xmlParser.delegate = self;
        xmlParser.parse()
        self.tableView.reloadData()
    }
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "list" {
            for (keys, _) in subjectItem {
                subjectItem.updateValue("", forKey: keys)
            }
        }
    }
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if subjectItem.keys.contains(currentElement) {
            subjectItem.updateValue(string, forKey: currentElement)
        }
    }
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = ""
        if elementName == "list" {
            subjectItems.append(subjectItem)
        }
    }
}
