//
//  ContentView.swift
//  swift-demo
//
//  Created by Eunika Wu on 5/17/21.
//  Copyright © 2021 LAIKA. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var webviewData = WebViewData()

    var body: some View {
        NavigationView {
            WebView(
                // url: URLType.publicURL(path: "https://laika.com"), // Example for public url
                url: URLType.localURL(path: "index"),                 // Example for local url
                webviewData: webviewData
            )
                .navigationBarTitle("Swift Demo", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
