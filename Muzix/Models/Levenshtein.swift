//
//  LevenshteinExtensions.swift
//  Levenshtein distance algorithm written in Swift 2.2. Both a slow and highly optimized version are included.
//
//  Created by Mark Hamilton on 3/31/16.
//  Copyright © 2016 dryverless. All rights reserved.
//

import Foundation

// Minimize 3
public func min3(a: Int, b: Int, c: Int) -> Int {
    return min( min(a, c), min(b, c))
}

public struct Array2D {
    var columns: Int
    var rows: Int
    var matrix: [Int]
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        
        self.rows = rows
        
        matrix = Array(repeating: 0, count:columns*rows)
    }
    
    subscript(column: Int, row: Int) -> Int {
        get {
            return matrix[columns * row + column]
        }
        
        set {
            matrix[columns * row + column] = newValue
        }
    }
    
    func columnCount() -> Int {
        return self.columns
    }
    
    func rowCount() -> Int {
        return self.rows
    }
}

public func levenshtein(sourceString: String, target targetString: String) -> Int {
    let source = Array(sourceString.unicodeScalars)
    let target = Array(targetString.unicodeScalars)
    
    let (sourceLength, targetLength) = (source.count, target.count)
    
    var distance = Array2D(columns: sourceLength + 1, rows: targetLength + 1)
    
    for x in 1...sourceLength {
        distance[x, 0] = x
    }
    
    for y in 1...targetLength {
        distance[0, y] = y
    }
    
    for x in 1...sourceLength {
        for y in 1...targetLength {
            if source[x - 1] == target[y - 1] {
                // no difference
                distance[x, y] = distance[x - 1, y - 1]
            } else {
                distance[x, y] = min3(
                    // deletions
                    a: distance[x - 1, y] + 1,
                    // insertions
                    b: distance[x, y - 1] + 1,
                    // substitutions
                    c: distance[x - 1, y - 1] + 1
                )
            }
        }
    }
    
    return distance[source.count, target.count]
    
}

public extension String {
    func getLevenshtein(target: String) -> Int {
        return levenshtein(sourceString: self, target: target)
    }
    
    func closestString(options: [String]) -> String {
        return options.min(by: { a, b in
            return self.getLevenshtein(target: a) < self.getLevenshtein(target: b)
        }) ?? "Gay Bar"
    }
}
