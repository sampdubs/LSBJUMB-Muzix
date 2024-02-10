/*
 See the LICENSE.txt file for this sample’s licensing information.
 
 Abstract:
 The root view controller that provides a button to start and stop recording, and which displays the speech recognition results.
 */

import AVFoundation
import Speech

public class SpeechRecognizer: ObservableObject {
    // MARK: Properties
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    @available(iOS 17, *)
    private var lmConfiguration: SFSpeechLanguageModel.Configuration {
        let outputDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let dynamicLanguageModel = outputDir.appendingPathComponent("LM")
        let dynamicVocabulary = outputDir.appendingPathComponent("Vocab")
        return SFSpeechLanguageModel.Configuration(languageModel: dynamicLanguageModel, vocabulary: dynamicVocabulary)
    }
    
    @MainActor var text = ""
    
    func loadModel() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // Divert to the app's main thread so that the UI
            // can be updated.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    if #available(iOS 17, *) {
                        Task.detached {
                            do {
                                let assetUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent("customlm.bin")
                                if !FileManager.default.fileExists(atPath: assetUrl.path()) {
                                    await trainModel(songs: getFiles(path: Bundle.main.resourcePath! + "/Songz/"))
                                }
                                try await SFSpeechLanguageModel.prepareCustomLanguageModel(for: assetUrl,
                                                                                           clientIdentifier: "com.lsjumb.Muzix",
                                                                                           configuration: self.lmConfiguration)
                                print("Finished preparing custom LM")
                            } catch {
                                print("Failed to prepare custom LM: \(error.localizedDescription)")
                            }
                        }
                    }
                default:
                    print("Not authorized")
                }
            }
        }
    }
    
    @MainActor private func startRecording() throws {
        if (!speechRecognizer.isAvailable) {
            print("Recognizer not available")
            return
        }
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        if #available(iOS 17, *) {
            recognitionRequest.customizedLanguageModel = self.lmConfiguration
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        speechRecognizer.defaultTaskHint = .search
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                // Update the text view with the results.
                self.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        
        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        text = ""
    }
    
    @MainActor func stop() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
    }
    
    @MainActor func start (){
        do {
            try startRecording()
        } catch {
            text = "Recording Not Available"
        }
    }
}

