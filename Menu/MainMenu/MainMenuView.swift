import SwiftUI

struct MainMenuView: View {
    var body: some View {
        VStack {
            Text("Defend Your Castle")
                .font(.largeTitle)
                .padding()
            
            Button(action: startGame) {
                Text("Start Game")
                    .font(.title)
                    .frame(width: 200,height: 50)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: openSettings) {
                Text("Settings")
                    .font(.title)
                    .frame(width: 200,height: 50)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: exitGame) {
                Text("Exit")
                    .font(.title)
                    .frame(width: 200,height: 50)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    func startGame() {
        // Start game logic
    }
    
    func openSettings() {
        // Navigate to settings
    }
    
    func exitGame() {
        // Handle exit logic 
    }
}

