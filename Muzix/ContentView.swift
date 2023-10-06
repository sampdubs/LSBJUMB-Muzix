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
        if (currentSong != nil){
            ZStack {
                PDFKitView(url: URL(fileURLWithPath: path + currentSong! + ".pdf"))
                closeButton
            }
    
        } else {
            ScrollView {
                VStack {
                    ForEach(self.getFiles(), id: \.self) { file in
                        Button(action: {
                            currentSong = file
                        }, label: {
                            Text(file)
                                .fontWeight(file == "Teazers" ? .black : .bold)
                        })
                    }
                }
            }
            .padding()
        }
    }
    
    var closeButton: some View {
        VStack {
            HStack {
                Button(action: {
                    currentSong = nil
                }) {
                    Image(systemName: "xmark.circle")
                        .padding(1)
                }
                Spacer()
            }
            .padding(.top, 5)
            Spacer()
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        pdfView.scaleFactor = 1.6
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitView>) {
        // TODO
    }
}


#Preview {
    ContentView()
}

