//
//  DictationView.swift
//  Muzix
//
//  Created by Sam Prausnitz-Weinbaum on 2/9/24.
//

import SwiftUI

struct DictationView: View {
    @State var micPressed = false
    //    let speechRecognizer: SpeechRecognizer
    @StateObject var speechRecognizer: SpeechRecognizer
    let recieveText: (String) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: micPressed ? "mic.fill" : "mic")
                    .font(.title)
                    .padding()
                    .foregroundStyle(.accent)
                Spacer()
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        beginRecording()
                    })
                    .onEnded({ _ in
                        endRecording()
                    })
            )
        }
    }
    
    @MainActor func beginRecording() {
        if (!micPressed) {
            speechRecognizer.start()
            micPressed = true
        }
    }
    
    @MainActor func endRecording() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            micPressed = false
            speechRecognizer.stop()
            print("Transcript: " + speechRecognizer.text)
            recieveText(speechRecognizer.text)
        }
    }
}

#Preview {
    DictationView(speechRecognizer: SpeechRecognizer(), recieveText: {(transcript: String) -> () in
        print(transcript)
    })
}
