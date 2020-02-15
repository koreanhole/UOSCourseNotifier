//
//  extension_Array_dropDuplicates.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/16.
//  Copyright © 2020 권순형. All rights reserved.
//

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
