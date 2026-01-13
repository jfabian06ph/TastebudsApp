//
//  String+Extensions.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/13/26.
//

import Foundation

extension String {
    func ranges(of search: String) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var startIndex = self.startIndex
        while startIndex < self.endIndex,
            let range = self[startIndex...].range(of: search, options: .caseInsensitive) {
            ranges.append(range)
            startIndex = range.upperBound
        }
        return ranges
    }
}
