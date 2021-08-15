import SwiftUI
import WebKit

class WebViewModel: ObservableObject {
    let webView: WKWebView
    let url: URL

    init() {
        webView = WKWebView(frame: .zero)
        // Copied from https://spielstein.com/games/mixtour/rules
        url = Bundle.main.url(forResource: "rules", withExtension: "html", subdirectory: "RulesFiles")!
        loadUrl()
    }

    func loadUrl() {
        webView.load(URLRequest(url: url))
    }
}
