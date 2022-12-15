//
//  EngSApp.swift
//  EngS
//
//  Created by vi nam on 15/11/2022.
//

import SwiftUI
import RealmSwift

let realmApp = RealmSwift.App(id: serverName)
let useEmailPasswordAuth = false


@main
struct EngSApp: SwiftUI.App {
    
    var body: some Scene {
        WindowGroup {
            
//            if let realmApp = realmApp {
            SyncContentView()
//            } else {
//                LocalOnlyContentView()
//            }
            
//            MainView(userHistory: $userDataVar.userSearchedWord)
            
//            MainView(userHistory: $userDataVar.userSearchedWord, words: $wordsList.wordList, wordsFlashCard: $wordsList.wordListFlashCard).onAppear(){
//                wordsList.wordList = load(fileName: "EWords446k")
//                wordsList.wordListFlashCard = load(fileName: "EWords2")
//                userDataVar.userSearchedWord = loadArrayFile(fileName: "userHistory.json")
//
//
//            }.onDisappear(){
//                let err = saveArrayFile(fileName: "userHistory.json", dataFile: userDataVar.userSearchedWord)
//            }
        
        }
    }
}




///
struct SyncContentView: View {
    // Observe the Realm app object in order to react to login state changes.
//    @ObservedObject var app: RealmSwift.App
    @State var username : String?

//    @ObservedResults(UserDataClassRealm.self) var usersDataRealm
//    @Environment(\.realm) var realm
    
    var body: some View {
        
      
        if let currentUser = realmApp.currentUser {
            let config = currentUser.flexibleSyncConfiguration(initialSubscriptions: { subs in
                // Check whether the subscription already exists. Adding it more
                // than once causes an error.
                if let foundSubscriptions = subs.first(named: "user") {
                    // Existing subscription found - do nothing
                    return
                } else {
                    // Add queries for any objects you want to use in the app
                    // Linked objects do not automatically get queried, so you
                    // must explicitly query for all linked objects you want to include
                    subs.append(QuerySubscription<UserDataClassRealm>(name: "user") {
                        // Query for objects where the ownerId is equal to the app's current user's id
                        // This means the app's current user can read and write their own data
                        $0.ownerId == currentUser.id
                    })

                }

            })
            
            OpenSyncedRealmView()
                            .environment(\.realmConfiguration, config)
            
   
        }else {
            
            if useEmailPasswordAuth {
                EmailLoginView(username: $username)
            } else {
                LoginView()
            }
            
        }

       
    }
}
//



struct OpenSyncedRealmView: View {
    @AsyncOpen(appId: serverName, timeout: 4000) var asyncOpen
    @State var wordsList = EngData()
    @StateObject var userDataVar = userDataClass()
//    @Environment(\.realm) var realm
    var body: some View {
        
        switch asyncOpen {
            
        case .connecting:
            ProgressView()
            // Waiting for a user to be logged in before executing
            // Realm.asyncOpen.
        case .waitingForUser:
            ProgressView("Waiting for user to log in...")
            // The realm has been opened and is ready for use.
            // Show the content view.
        case .open(let realm):
            
            
            
            
            MainView(userHistory: $userDataVar.userSearchedWord, words: $wordsList.wordList, wordsFlashCard: $wordsList.wordListFlashCard, userDataRealm:{
                
                let obcount = realm.objects(UserDataClassRealm.self).count
//                let userID = realmApp.currentUser.id
                let userID = realmApp.currentUser?.id
                if obcount == 0 {
                    let temp = UserDataClassRealm(value: ["ownerId":userID])
                    try! realm.write {
                        // Because we're using `ownerId` as the queryable field, we must
                        // set the `ownerId` to equal the `user.id` when creating the object
                        realm.add(temp)
                    }
                }
                
                return realm.objects(UserDataClassRealm.self).first!
            }()
            ).environment(\.realm, realm).onAppear(){
                wordsList.wordList = load(fileName: "EWords446k")
                wordsList.wordListFlashCard = load(fileName: "EWords2")
                userDataVar.userSearchedWord = loadArrayFile(fileName: "userHistory.json")
                
                
                
            }
        case .progress(let progress):
            ProgressView(progress)
        case .error(let error):
            ErrorView(error: error)
        }
        
        
    }
    
//    private func setSubscriptions() {
//        let subscriptions = realm.subscriptions
//
//    }
}
