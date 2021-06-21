# swift-demo

Proof-of-concept iOS app that includes a webview and bluetooth manager. 

In this application, we include a webview to a web application that interacts with native iOS bluetooth capabilities. 
You can select from a list of nearby devices and connect to it through the iOS UI. Connecting to a device or changing the bluetooth state will trigger updates to the web app. 

This project is built using [SwiftUI](https://developer.apple.com/documentation/swiftui/) on Xcode 12.4 & 12.5 for iOS 14.4+.


## Webview

There is no native Webview View in SwiftUI at the time of writing. Instead, we can define a wrapper view that adopts the  `UIViewRepresentable` protocol and returns `WKWebView` from WebKit.

### Rendering the webview

You must implement these methods from the  `UIViewRepresentable` protocol:

- `makeUIView`: creates and returns a `WKWebView` instance
- `updateUIView`: loads the webview with a local or public web page

### Evaluating JS

To evaluate JavaScript in the webview, you must define a *coordinator delegate*. [SwiftUI coordinators](https://developer.apple.com/documentation/swiftui/nsviewcontrollerrepresentablecontext/coordinator) act as delegates that respond to events that occur elsewhere. The coordinator pattern is used extensively in SwiftUI. 

- In `WebView`, we define the `WebView.Coordinator` class, which extends `NSObject` and adopts the `WKScriptMessageHandler`
- In `makeUIView`, we instantiate the coordinator and link it to `WKWebView.configuration.userContentController`
- In `updateUIView`, we evaluate JS using the coordinator

### Evoke JS from elsewhere in the app

Our webview can evaluate JS, but to trigger JS from elsewhere in the app, we need to make our webview contain a property that adopts the [`ObservableObject`](https://developer.apple.com/documentation/combine/observableobject) protocol. This protocol allows instances of this class to be used inside views, so that updates within the object trigger updates to the view.

- In `WebView`, we add `@ObservedObject var webviewData` as a parameter
- In `ContentView`, we instantiate `webviewData` and pass it into the webview
- We can then define callbacks that invoke `webviewData.evaluateJS` to trigger JS from elsewhere in the app


## Bluetooth

TODO