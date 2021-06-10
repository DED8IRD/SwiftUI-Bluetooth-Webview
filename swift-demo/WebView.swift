//
//  WebView.swift
//  swift-demo
//
//  SwiftUI does not have a native WebView view. Here, we define a wrapper view that returns
//  WKWebView from WebKit. Largely inspired from https://github.com/yamin335/SwiftUIWebView
//
//  Created by Eunika Wu on 5/18/21.
//  Copyright © 2021 LAIKA. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    /// URL to load into WebView
    let url: URL?

    /// Create WebView
    /// - Parameter context: WebView context
    /// Returns WebKit WebView
    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
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
