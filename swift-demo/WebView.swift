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

/// WebView wrapper view
struct WebView: UIViewRepresentable {

    /// URL to load into WebView
    let url: URLType?

    /// Initialize a coordinator to coordinate WKWebView's delegate functions
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self)
    }

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
    /// - Parameter webview: WebKit WebView
    /// - Parameter context: WebView context
    func updateUIView(_ webview: WKWebView, context: Context) {
        switch url {
            case .localURL(let path):
                let request = Bundle.main.url(forResource: path, withExtension: "html", subdirectory: "www")!
                webview.loadFileURL(request, allowingReadAccessTo: (request.deletingLastPathComponent()))
            case .publicURL(let path):
                let request = URLRequest(url: URL(string: path)!)
                webview.load(request)
            case .none:
                print("No path supplied.")
                fatalError()
        }
    }
}

/// Coordinator to act as a delegate for the WebView
// SwiftUI coordinators act as delegates that respond to events that occur elsewhere.
// This coordinator will allow us to access the webview object in our bluetooth manager
// to trigger some JS during bluetooth connections and updates.
class WebViewCoordinator: NSObject, WKNavigationDelegate {

    /// Parent View object
    var parent: WebView
    /// Delegate to access the inner WebKit WebView object
    weak var delegate: WKWebView?

    init(_ webview: WebView) {
        self.parent = webview
    }
}

enum URLType {
    case localURL(path: String)
    case publicURL(path: String)
}
