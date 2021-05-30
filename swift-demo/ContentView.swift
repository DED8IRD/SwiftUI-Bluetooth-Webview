//
//  ContentView.swift
//  swift-demo
//
//  Created by Eunika Wu on 5/17/21.
//  Copyright © 2021 LAIKA. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WebView(url: URL(string: "https://laika.com"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
