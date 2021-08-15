import SwiftUI
import WebKit

class WebViewModel: ObservableObject {
    let webView: WKWebView
    let url: URL

    init() {
        webView = WKWebView(frame: .zero)
        url = URL(string: "https://www.spiegel.de")!
        loadUrl()
    }

    func loadUrl() {
        webView.load(URLRequest(url: url))
    }
}
