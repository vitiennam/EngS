//
//  EngSApp.swift
//  EngS
//
//  Created by vi nam on 15/11/2022.
//

import SwiftUI

@main
struct EngSApp: App {
    @State var wordsList = EngData()
    @StateObject var userDataVar = userDataClass()
    var body: some Scene {
        WindowGroup {
//            MainView(userHistory: $userDataVar.userSearchedWord)
            MainView(userHistory: $userDataVar.userSearchedWord, words: $wordsList.wordList).onAppear(){
                wordsList.wordList = load(fileName: "EWords446k")
            }
        
        }
    }
}
