//
//  DictationView.swift
//  Muzix
//
//  Created by Sam Prausnitz-Weinbaum on 2/9/24.
//

import SwiftUI

struct DictationView: View {
    @State var micPressed = false
    @StateObject var speechRecognizer: SpeechRecognizer
    let recieveText: (String) -> Void
    @State var startRecording = DispatchTime.now()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Group {
                    Image(systemName: micPressed ? "mic.fill" : "mic")
                        .font(.title)
                        .padding()
                        .foregroundStyle(.accent)
                }
                .contentShape(Rectangle())
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.accent, lineWidth: 4)
                )
                .padding()
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ _ in
                            beginRecording()
                        })
                        .onEnded({ _ in
                            endRecording()
                        })
                )
                .sensoryFeedback(trigger: micPressed) { old, new in
                    return (old ? .success : .impact(flexibility: .solid, intensity: 1))
                }
            }
        }
    }
    
    @MainActor func beginRecording() {
        if (!micPressed) {
            micPressed = true
            startRecording = .now()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                speechRecognizer.start()
            }
        }
    }
    
    @MainActor func endRecording() {
        DispatchQueue.main.asyncAfter(deadline: max(startRecording.advanced(by: .seconds(2)), .now().advanced(by: .milliseconds(500)))) {
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
