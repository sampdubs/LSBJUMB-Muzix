//
//  SongListView.swift
//  Muzix
//
//  Created by Sam Prausnitz-Weinbaum on 2/8/24.
//

import SwiftUI

struct SongListView: View {
    let songs: [String]
    let onClick: (String) -> Void
    
    var body: some View {
        ScrollView {
            HStack{
                Spacer()
                VStack {
                    ForEach(songs, id: \.self) { file in
                        Button(action: {
                            onClick(file)
                        }, label: {
                            Text(file)
                                .fontWeight(file == "Teazers" ? .black : .bold)
                        })
                    }
                }
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    SongListView(songs: ["Song 1", "Song 2"], onClick: {
        print("Clicked on " + $0)
    })
}
