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
    
    var body: some View {
        ZStack {
            if (currentSong != nil) {
                ZStack {
                    PDFKitView(url: URL(fileURLWithPath: path + currentSong! + ".pdf"))
                    CloseButton(closeAction: {
                        currentSong = nil
                    })
                    if (currentSong == "Stuff Like That") {
                        SwitchSong(onClick: {
                            currentSong = nil
                            let newSong: String = $0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                currentSong = newSong
                            }
                        }, songName: "Whisper Your Name")
                    } else if (currentSong == "White Punks on Dope") {
                        SwitchSong(onClick: {
                            currentSong = nil
                            let newSong: String = $0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                currentSong = newSong
                            }
                        }, songName: "All Right Now")
                    }
                }
                
            } else {
                SongListView(songs: getFiles(path: path), onClick: {
                    currentSong = $0
                })
            }
            DictationView(speechRecognizer: speechRecognizer, recieveText: { text in
                currentSong = nil
                if (text != "") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        currentSong = text.closestString(options: getFiles(path: path))
                    }
                }
            })
        }
    }
}


#Preview {
    ContentView()
}

struct SwitchSong: View {
    let onClick: (String) -> Void
    let songName: String
    
    var body: some View {
        HStack {
            VStack{
                Spacer()
                Button(action: {
                    onClick(songName)
                }, label: {
                    Text(songName)
                        .fontWeight(.bold)
                })
                .padding(8)
            }
            Spacer()
        }
    }
}
