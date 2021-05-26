//
//  WebView.swift
//  swift-demo
//
//  Created by Eunika Wu on 5/18/21.
//  Copyright © 2021 LAIKA. All rights reserved.
//

import SwiftUI
import WebKit

struct UIWebView: UIViewRepresentable {
    
    /// URL to load into WebView
    let url: URL?
    
    /// Create WebView
    /// - Parameter context: WebView context
    /// Returns WebKit WebView
    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKPreferences()
        prefs.javaScriptEnabled = true
        let config = WKWebViewConfiguration()
        config.preferences = prefs
        return WKWebView(frame: .zero, configuration: config)
    }
    
    
    /// Update WebView with url if the url exists
    /// - Parameter uiView: WebKit WebView
    /// - Parameter context: WebView context
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let webviewURL = url else { return }
        let request = URLRequest(url: webviewURL)
        uiView.load(request)
    }
}
