//
//  ContentView.swift
//  EngS
//
//  Created by vi nam on 15/11/2022.
//

import SwiftUI
import RealmSwift
struct MainView: View {
    @State var searchString = ""
    @State var randomText = ""
    @State var onEditingText = false
//    @State var username : String
//    @State var words :[String] = ["a", "abandon", "ability", "able", "abolish", "red"]
//    @StateObject var userHistoryM = userDataClass()
    @Binding var userHistory : [String]
    @Binding var words :[String]
    @Binding var wordsFlashCard :[String]
    @ObservedRealmObject var userDataRealm : UserDataClassRealm
//    @ObservedResults(UserDataClassRealm.self) var usersDataRealm
//    @Environment(\.realm) var realm
    
    @State var inProgress = false
    var body: some View {
        
        NavigationView {
            TabView{
               
                VStack {
                    
                    ExtractedView(searchString: $searchString, onEditingText: $onEditingText)
                    List {
                        ForEach(words.filter({
                            return $0.hasPrefix(searchString.lowercased()) && onEditingText && (searchString != "")
                        }).prefix(10), id: \.self) {
                            word in
                            NavigationLink(word, destination: WordView(wordSearch: word, userHistory: $userHistory, userSearchedRealm: $userDataRealm.userSearchedWord, userDataRealm: userDataRealm))

                        }
                        
                    
                    }
 
                    Text("searching: \(searchString)")
                    Text("array His: \(userHistory.count)")
                    Text("array His Realm: \(userDataRealm.userSearchedWord.count)")
//                    List() {
//                        ForEach(userHistoryM.userSearchedWord, id: \.self){ wordSearched in
//                            Text(wordSearched)
//
//                        }}
                }.tabItem{ Text("Search")}
                
                VStack {
                    Text("Just tab the word")
                    Spacer()
                    NavigationLink(randomText, destination: WordView(wordSearch: randomText, userHistory: $userHistory, userSearchedRealm: $userDataRealm.userSearchedWord, userDataRealm: userDataRealm))
                    Spacer()
                    
                    
                }.tabItem{Text("Flash card")}.onAppear(){
                    randomText = wordsFlashCard.randomElement() ?? "error"
//                    $userDataRealm.userSearchedWord.append(randomText)
                }
                
                VStack {
                    
                    List() {
//                        ForEach(userHistory, id: \.self){ wordSearched in
//                            NavigationLink(wordSearched, destination: WordView(wordSearch: wordSearched, userHistory: $userHistory))
//
//                        }
                        
                        ForEach(userDataRealm.userSearchedWord.reversed(), id: \.self){ wordSearched in
                            NavigationLink(wordSearched, destination: WordView(wordSearch: wordSearched, userHistory: $userHistory, userSearchedRealm: $userDataRealm.userSearchedWord, userDataRealm: userDataRealm))
                            
                        }
                        
                        
                        
                    }

                        
                        
                    
                }.tabItem{
                    Text("History")
                

                }
                    
                    
            }
        }
        
        
    }
    
//    private func setSubscriptions() {
//
//            let subscriptions = realm.subscriptions
//            if subscriptions.first(named: product) == nil {
//                inProgress = true
//                subscriptions.update() {
//                subscriptions.append(QuerySubscription<Ticket>(name: product) { ticket in
//                    ticket.product == product &&
//                    (
//                        ticket.status != .complete || ticket.created > lastYear
//                    )
//                })
//                } onComplete: { _ in
//                    inProgress = false
//                }
//            }
//
//    }
    
    
    
}

//struct MainView_Previews: PreviewProvider {
//    
//    
//    static var previews: some View {
//        
//        MainView()
//    }
//}

struct ExtractedView: View {
    @Binding var searchString : String
    @Binding var onEditingText : Bool
    var body: some View {
        ZStack{
            
            Rectangle().foregroundColor(Color("lightgray")).frame(height: 40)
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search ...", text:  $searchString,onEditingChanged: {
                    editing in
                    onEditingText = true
                }, onCommit: {
                    
                    onEditingText = false
                }).foregroundColor(.black)
                
            }
            
            
        }.cornerRadius(13)
            .padding()
    }
}
