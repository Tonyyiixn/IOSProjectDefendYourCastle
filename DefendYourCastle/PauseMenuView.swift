//
//  PauseMenuView.swift
//  DefendYourCastle
//
//  Created by Yixin Chen on 10/17/24.
//

import SwiftUI

struct PauseMenuView: View {
    

    var body: some View {
        VStack {
            Text("Paused")
                .font(.largeTitle)
                .padding()

            Button(action: restartAction) {
                Text("Restart")
                    .font(.title)
                    .padding()
            }

            Button(action: quitAction) {
                Text("Quit")
                    .font(.title)
                    .padding()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.8))
        .cornerRadius(10)
    }
    func restartAction() {
        // Start game logic
    }
    
    func quitAction() {
        // Navigate to settings
    }
    
    
}
