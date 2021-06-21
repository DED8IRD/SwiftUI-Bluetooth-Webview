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

We define a bluetooth manager that handles scanning for bluetooth status updates, nearby devices ("peripherals"), and device connections. 

### BLEManager

#### CoreBluetooth

`BLEManager` adopts the `CBCentralManagerDelegate` protocol, which allows it to access BLE state (bluetooth on/off/unsupported/etc.), and define behavior for discovering  and connecting to peripherals. 

`BLEManager` also adopts the `CBPeripheralDelegate` protocol, which allows it to access peripheral services and characteristics.

### Evoke JS when handling bluetooth events

We want to trigger update to the webview when the bluetooth state changes: i.e. render updates when bluetooth changes from on/off and display which peripheral we connect to.

We accomplish this by defining callback params in `BLEManager` in `ContentView`: `onBluetoothStateChange` & `onDeviceConnectionChange`

These callbacks evaluate JS in the webview and evoke RPC methods in our web app (see `/www/index.html`).

### Evoke bluetooth events when handling JS events

We can also trigger events in our iOS app from the web app's side through invoking our delegate functions.

In `/www/index.html`:
```js
window.addEventListener('load', _ => {
    // Invoke function from webview
    window.webkit.messageHandlers.iOSNative.postMessage("Loaded");
});
```

We configured our webview coordinator via `WKWebView.configuration.userContentController` and gave it the name `iOSNative`. 
We can send messages to our iOS app via `window.webkit.messageHandlers.${DELEGATE_NAME}.postMessage(${MESSAGE})`. 
In the example above, we want to signal to our iOS app when the webpage is fully loaded so we can immediately render the bluetooth status.


