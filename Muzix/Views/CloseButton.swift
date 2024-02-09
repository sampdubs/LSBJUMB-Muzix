//
//  CloseButton.swift
//  Muzix
//
//  Created by Sam Prausnitz-Weinbaum on 2/8/24.
//

import SwiftUI

struct CloseButton: View {
    let closeAction: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button(action: closeAction) {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                        .padding(1)
                }
                Spacer()
            }
            .padding(.top, 5)
            Spacer()
        }
    }
}

#Preview {
    CloseButton(closeAction: {
        print("Close!")
    })
}
