//
//  ContentView.swift
//  Muzix
//
//  Created by Sam Prausnitz-Weinbaum on 10/5/23.
//

import SwiftUI
import PDFKit

struct ContentView: View {
    @State private var currentSong: String?
    private let path = Bundle.main.resourcePath! + "/Songz/"
    
    var speechRecognizer = SpeechRecognizer()
    
    func getFiles() -> [String] {
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
    
    var body: some View {
        ZStack {
            if (currentSong != nil) {
                ZStack {
                    PDFKitView(url: URL(fileURLWithPath: path + currentSong! + ".pdf"))
                    CloseButton(closeAction: {
                        currentSong = nil
                    })
                }
                
            } else {
                SongListView(songs: self.getFiles(), onClick: {
                    currentSong = $0
                })
            }
            DictationView(speechRecognizer: speechRecognizer, recieveText: { text in
                currentSong = nil
                if (text == "") {
                    print("Didn't hear that")
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        currentSong = text.closestString(options: self.getFiles())
                    }
                }
            })
        }
    }
}


#Preview {
    ContentView()
}
