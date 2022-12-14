//
//  WordView.swift
//  EngS
//
//  Created by vi nam on 15/11/2022.
//

import SwiftUI
import WebKit
import RealmSwift
struct WordView: View {
    @State var wordSearch : String
    @Binding var userHistory : [String]
//    @ObservedRealmObject var userDataRealm : UserDataClassRealm
    @Binding var userSearchedRealm : RealmSwift.List<String>
    @ObservedRealmObject var userDataRealm : UserDataClassRealm
    var body: some View {
        
        VStack {
//            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).foregroundColor(.gray)
//            HStack {
                TabView {
                    WordWebView(request: URLRequest(url: URL(string: "https://www.oxfordlearnersdictionaries.com/definition/american_english/\(wordSearch)?q=\(wordSearch)")!)).tabItem{
                        Text("Oxford")
                    }
                    WordWebView(request: URLRequest(url: URL(string: "https://dictionary.cambridge.org/dictionary/english-vietnamese/\(wordSearch)")!)).tabItem{
                        Text("Cambridge")
                    }
                    WordWebView(request: URLRequest(url: URL(string: "https://translate.google.com/?hl=vi&sl=en&tl=vi&text=\(wordSearch)&op=translate")!)).tabItem{
                        Text("GG")
                    }
                }.accentColor(.red)
//            }
               

     

        }.onDisappear(){
            userHistory = userHistory.filter(){
                $0 != wordSearch
            }
//            userHistory.append(wordSearch)
            userHistory.insert(wordSearch, at: 0)
            let err = saveArrayFile(fileName: "userHistory.json", dataFile: userHistory)
//            $userDataRealm.userSearchedWord.append(wordSearch)
//            userSearchedRealm.append(wordSearch)
            
            let duplicated = userDataRealm.userSearchedWord.filter(){
                $0 == wordSearch
            }
            if duplicated.isEmpty {
                $userDataRealm.userSearchedWord.append(wordSearch)

                
            }
            
        }
        
    }
}

//struct WordView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        WordView(wordSearch: "hi")
//    }
//}
