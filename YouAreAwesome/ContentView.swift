//
//  ContentView.swift
//  YouAreAwesome
//
//  Created by Richard Isaacs on 26.08.22.
//

import SwiftUI
import AVFAudio

/// Eat the provided specialty sloth food.
///
/// Sloths love to eat while they move very slowly through their rainforest
/// habitats. They're especially happy to consume leaves and twigs, which they
/// digest over long periods of time, mostly while they sleep.
///
/// When they eat food, a sloth's `energyLevel` increases by the food's `energy`.
///
/// - Parameters:
///   - food: The food for the sloth to eat.
///   - quantity: The quantity of the food for the sloth to eat.
///
/// - Returns: The sloth's energy level after eating.
///
///
func printv( _ data : Any)-> EmptyView{
    print(data)
    return EmptyView()
}

struct ContentView: View {
    @State private var messageString = ""
    @State private var imageName = ""
    
    @State private var lastImageNumber = -1
    @State private var lastMessageNumber = -1
    @State private var lastSoundNumber = -1
    
    @State private var audioPlayer: AVAudioPlayer!
    
    @State private var soundIsOn = true
    //
    
    var body: some View {
        
        VStack  (alignment: .center) {
            
            printv("test v2")
            
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                Text ("simulation")
            }
            Text("iOS Version: \(UIDevice.current.systemVersion)")
            Text("Device: \(UIDevice.current.name)")
            
            Text(messageString)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
                .frame(height: 150)
                .frame(maxWidth: .infinity)
                .border(.orange, width: 1)
                .padding()
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(30)
                .shadow(radius: 30)
                .padding()
            //                .animation(.default, value: messageString)
                .animation(.easeInOut(duration: 0.15), value: messageString)
            
            Spacer()
            
            HStack {
                
                Text("Sound ON:")
                Toggle("", isOn: $soundIsOn)
                    .labelsHidden()
                    .onChange(of: soundIsOn) { newValue in
                        if audioPlayer != nil && audioPlayer.isPlaying {
                            audioPlayer.stop()
                        }
                    }
                
                
                Button("Show Message") {
                    
                    let messages = ["one","two","three ","four", "five"]
                    
                    lastMessageNumber = nonRepeatingRandom(lastNumber: lastMessageNumber,
                                                           upperBounds: messages.count-1)
                    messageString = messages[lastMessageNumber]
                    
                    lastImageNumber = nonRepeatingRandom(lastNumber: lastImageNumber,
                                                         upperBounds: 2)
                    
                    imageName = "image\(lastImageNumber)"
                    
                    lastSoundNumber = nonRepeatingRandom(lastNumber: lastSoundNumber,
                                                         upperBounds: 5)
                    let soundName = "sound\(lastSoundNumber)"
                    
                    if soundIsOn {
                        playSound(soundName: soundName)
                    }
                    
                } // Button
                .buttonStyle(.borderedProminent)
            } // HStack
            .tint(.indigo)
        }
        .padding()
    }
    
    //////
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print ("\(soundName) not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print ("😀ERROR play \(error.localizedDescription)")
        }
        
    } // playSound
    
    func nonRepeatingRandom(lastNumber: Int, upperBounds: Int) -> Int {
        
        var number: Int
        repeat {
            number = Int.random(in: 0...upperBounds)
            
        } while lastNumber == number
        
        return number
        
    } // nonRepeatingRandom
    
} // ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        // NOTE: phone must in list of available simulators, otherwise
        //       defaults to currently selected device
        //let simModel = "iPhone 14"
        //let simModel = "iPhone SE (3rd generation)"  // must be exact simulator name
        // let simModel = "iPhone 13"
        //let name = UIDevice.current.name  // always uses the active simulator name, will not change
        
        ContentView()
            //        .previewDevice(PreviewDevice(rawValue: simModel))
            //                .previewDisplayName(name)
            //                .previewInterfaceOrientation(.portrait)
            .previewDisplayName(UIDevice.current.name)
            .previewInterfaceOrientation(.portrait)
    }
}
