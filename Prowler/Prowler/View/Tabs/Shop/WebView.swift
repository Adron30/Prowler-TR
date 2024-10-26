import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    let onNavigationAction: (WKNavigationAction) -> Void

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onNavigationAction: onNavigationAction)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var onNavigationAction: (WKNavigationAction) -> Void

        init(onNavigationAction: @escaping (WKNavigationAction) -> Void) {
            self.onNavigationAction = onNavigationAction
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            onNavigationAction(navigationAction)
            decisionHandler(.allow)
        }
    }
}
