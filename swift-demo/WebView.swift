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
    let url: URLType?

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
        switch url {
            case .localURL(let path):
                let request = Bundle.main.url(forResource: path, withExtension: "html", subdirectory: "www")!
                uiView.loadFileURL(request, allowingReadAccessTo: (request.deletingLastPathComponent()))
            case .publicURL(let path):
                let request = URLRequest(url: URL(string: path)!)
                uiView.load(request)
            case .none:
                print("No path supplied.")
                fatalError()
        }
    }
}

enum URLType {
    case localURL(path: String)
    case publicURL(path: String)
}
