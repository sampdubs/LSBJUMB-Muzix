/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A simple utility for generating Custom LM training data
*/

import Speech

func trainModel(songs: [String]) async {
    let data = SFCustomLanguageModelData(locale: Locale(identifier: "en_US"), identifier: "com.lsjumb.Muzix", version: "1.0") {
        for song in songs {
            SFCustomLanguageModelData.PhraseCount(phrase: song, count: 100)
        }
    }
    
    do {
        let assetUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent("customlm.bin")
        try await data.export(to: assetUrl)
        print("Exported new model")
    } catch {
        print("Error explorting custom model")
    }
}
