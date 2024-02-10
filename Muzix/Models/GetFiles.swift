//
//  GetFiles.swift
//  Muzix
//
//  Created by Sam Prausnitz-Weinbaum on 2/9/24.
//

import Foundation

func getFiles(path: String) -> [String] {
    let fm = FileManager.default
    
    do {
        var items = try fm.contentsOfDirectory(atPath: path)
        for i in 0..<items.count {
            let index = items[i].index(items[i].endIndex, offsetBy: -5)
            items[i] = String(items[i][...index])
        }
        items = items.sorted()
        items.remove(at: items.firstIndex{$0 == "Teazers"}!)
        items.insert("Teazers", at: 0)
        return items
    } catch {
        return ["Error"]
    }
}
