//
//  ContentView.swift
//  EngS
//
//  Created by vi nam on 15/11/2022.
//

import SwiftUI

struct MainView: View {
    @State var searchString = ""
    @State var randomText = ""
    @State var onEditingText = false
//    @State var words :[String] = ["a", "abandon", "ability", "able", "abolish", "red"]
//    @StateObject var userHistoryM = userDataClass()
    @Binding var userHistory : [String]
    @Binding var words :[String]
    var body: some View {
        
        NavigationView {
            TabView{
               
                VStack {
                    
                    ExtractedView(searchString: $searchString, onEditingText: $onEditingText)
                    List {
                        ForEach(words.filter({
                            return $0.hasPrefix(searchString.lowercased()) && onEditingText && (searchString != "")
                        }), id: \.self) {
                            word in
                            NavigationLink(word, destination: WordView(wordSearch: word, userHistory: $userHistory))

                        }
                        
                    
                    }
 
                    Text("searching: \(searchString)")
                    Text("array His: \(userHistory.count)")
//                    List() {
//                        ForEach(userHistoryM.userSearchedWord, id: \.self){ wordSearched in
//                            Text(wordSearched)
//
//                        }}
                }.tabItem{ Text("Search")}
                
                VStack {
                    Text("Just tab the word")
                    Spacer()
                    NavigationLink(randomText, destination: WordView(wordSearch: randomText, userHistory: $userHistory))
                    Spacer()
                    
                }.tabItem{Text("Flash card")}.onAppear(){
                    randomText = words.randomElement() ?? "error"
                }
                
                VStack {
                    
                    List() {
                        ForEach(userHistory, id: \.self){ wordSearched in
                            NavigationLink(wordSearched, destination: WordView(wordSearch: wordSearched, userHistory: $userHistory))
//                            Text(wordSearched)
                            
                        }
                    }
                }.tabItem{
                    Text("History")
                
//                Text("Learn New Word").padding().border(.gray).cornerRadius(10).shadow(radius: 7)
                }
                    
                    
            }
        }
        
        
    }
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
