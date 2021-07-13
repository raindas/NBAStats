//
//  WebView.swift
//  NBAStats
//
//  Created by President Raindas on 09/07/2021.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    //https://upload.wikimedia.org/wikipedia/en/d/dc/Phoenix_Suns_logo.svg
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
        uiView.sizeToFit()
        uiView.load(request)
    }
    
}

#if DEBUG
struct WebView_Previews : PreviewProvider {
    static var previews: some View {
        WebView(request: URLRequest(url: URL(string: "https://upload.wikimedia.org/wikipedia/en/d/dc/Phoenix_Suns_logo.svg")!))
    }
}
#endif
