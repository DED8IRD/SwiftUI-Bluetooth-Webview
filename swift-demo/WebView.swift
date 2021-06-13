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
import Combine

/// WebView wrapper view
struct WebView: UIViewRepresentable {

    /// URL to load into WebView
    let url: URLType?
    /// WebView data
    @ObservedObject var webviewData: WebViewData
    /// WebView delegate name
    let webviewDelegateName = "iOSNative"

    /// Coordinator to coordinate WKWebView's delegate functions
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    /// Create WebView
    /// - Parameter context: WebView context
    /// Returns WebKit WebView
    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        // Add webview delegate coordinator to our config
        config.userContentController.add(self.makeCoordinator(), name: webviewDelegateName)
        return WKWebView(frame: .zero, configuration: config)
    }

    /// Update WebView with url if the url exists
    /// - Parameter webview: WebKit WebView
    /// - Parameter context: WebView context
    func updateUIView(_ webview: WKWebView, context: Context) {
        context.coordinator.delegate = webview
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

    /// Coordinator to act as a delegate for the WebView
    // SwiftUI coordinators act as delegates that respond to events that occur elsewhere.
    // This coordinator will allow us to access the webview object in our bluetooth manager
    // to trigger some JS during bluetooth connections and updates.
    class Coordinator: NSObject {

        /// Parent View object
        var parent: WebView
        /// Delegate to access the inner WebKit WebView object
        weak var delegate: WKWebView?

        init(_ webview: WebView) {
            self.parent = webview
        }

        /// Evaluate JS wrapper
        func evaluateJavaScript(data: WebViewData) -> AnyCancellable {
            return data.evaluateJS.sink(receiveValue: { rawJS in
                self.delegate?.evaluateJavaScript(rawJS)
            })
        }
    }
}

/// Extend Coordinator to handle JS messages
extension WebView.Coordinator: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // Make sure your passed delegate is called
        if message.name == self.parent.webviewDelegateName {
            print("Message received: \(message.body)")
        }
    }
}

/// WebView observable object class to access webview state throughout the application
class WebViewData: ObservableObject {
    /// Passthrough raw JS to evaluate in WKWebView instance
    var evaluateJS = PassthroughSubject<String, Never>()
}

enum URLType {
    case localURL(path: String)
    case publicURL(path: String)
}
