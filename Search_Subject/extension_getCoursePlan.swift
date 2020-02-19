//
//  extension_getCoursePlan.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/20.
//  Copyright © 2020 권순형. All rights reserved.
//

import Foundation

import Foundation


extension CoursePlanTableViewController: XMLParserDelegate {
    
    func requestCoursePlan(subjectNo: String, classDiv: String) -> (coursePlan: [String:String], courseWeeklyPlan: [[String:String]]) {
        let query: [String: String] = [
            //권순형 apikey = 202001610WYX35223
            //허가경 apikey = 202002614AWS86830
            "apiKey": "202002614AWS86830",
            "year": "2020",
            "term": "A10",
            "subjectNo": subjectNo,
            "classDiv" : classDiv
        ]
        let baseURL = URL(string: "https://wise.uos.ac.kr/uosdoc/api.ApiApiCoursePlanView.oapi?")!
        
        guard let url = baseURL.withQueries(query) else {
            
            print("Unable to build URL with supplied queries.")
            return ([:], [[:]])
        }
        guard let xmlParser = XMLParser(contentsOf: url) else { return ([:], [[:]]) }
        xmlParser.delegate = self;
        xmlParser.parse()
        
        let weeklyPlanKeys:[String] = ["week", "class_cont", "class_meth", "week_book", "prjt_etc"]
        var coursePlan = [String:String]()
        var courseWeeklyPlan = [[String:String]]()
        
        let tempDict = coursePlanItems.first!
        
        for (key, value) in tempDict {
            if !weeklyPlanKeys.contains(key) {
                coursePlan[key] = value
            }
        }
        

        for dict in coursePlanItems {
            var tempDict = [String:String]()
            for (keys, values) in dict {
                if weeklyPlanKeys.contains(keys) {
                    tempDict[keys] = values
                }
            }
            courseWeeklyPlan.append(tempDict)
        }
        
        return (coursePlan, courseWeeklyPlan)
    }
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "list" {
            for (keys, _) in coursePlanItem {
                coursePlanItem.updateValue("", forKey: keys)
            }
        }
    }
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if coursePlanItem.keys.contains(currentElement) {
            coursePlanItem.updateValue(string, forKey: currentElement)
        }
    }
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = ""
        if elementName == "list" {
            coursePlanItems.append(coursePlanItem)
        }
    }
}

