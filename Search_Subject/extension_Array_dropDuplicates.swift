//
//  extension_Array_dropDuplicates.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/16.
//  Copyright © 2020 권순형. All rights reserved.
//  배열의 중복된 값 제거하는 함수

import Foundation

extension Array where Element:Equatable {
    func dropDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
