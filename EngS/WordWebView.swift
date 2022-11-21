//
//  WordWebView.swift
//  EngS
//
//  Created by vi nam on 15/11/2022.
//

import SwiftUI
import WebKit
struct WordWebView: UIViewRepresentable {
    let request : URLRequest
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}

struct WordWebView_Previews: PreviewProvider {
    static var previews: some View {
        WordWebView(request: URLRequest(url: URL(string: "https://www.apple.com")!))
    }
}
