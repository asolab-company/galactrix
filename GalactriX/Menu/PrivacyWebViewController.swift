import UIKit
import WebKit

final class PrivacyWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    private static let pasteURL = PinGameLinks.pastebin
    private static let policyURL = URL(string: "https://malyshewandrew.tilda.ws/privacypolicygalactrix")!
    private static let allowedHosts = PinGameLinks.pastebinHosts.union(["malyshewandrew.tilda.ws"])

    private let webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        return WKWebView(frame: .zero, configuration: configuration)
    }()
    private let spinner = UIActivityIndicatorView(style: .large)
    private let errorPanel = UIStackView()
    private var requestedURL = pasteURL

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Privacy Policy"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        webView.accessibilityIdentifier = "privacy-webview"
        webView.navigationDelegate = self
        webView.uiDelegate = self

        let message = UILabel()
        message.text = "This page couldn’t be loaded."
        message.font = .preferredFont(forTextStyle: .body)
        message.adjustsFontForContentSizeCategory = true
        message.textAlignment = .center
        message.numberOfLines = 0
        let retry = UIButton(configuration: .borderedProminent())
        retry.configuration?.title = "Try again"
        retry.accessibilityIdentifier = "privacy-retry"
        retry.addTarget(self, action: #selector(loadPage), for: .touchUpInside)
        retry.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        errorPanel.axis = .vertical
        errorPanel.alignment = .center
        errorPanel.spacing = 14
        errorPanel.addArrangedSubview(message)
        errorPanel.addArrangedSubview(retry)

        spinner.hidesWhenStopped = true
        spinner.accessibilityLabel = "Loading page"
        [webView, spinner, errorPanel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            webView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spinner.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            errorPanel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            errorPanel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            errorPanel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
        updateNavigation()
        loadPage()
    }

    @objc private func loadPage() {
        startLoading()
        webView.load(URLRequest(url: requestedURL, timeoutInterval: 25))
    }

    private func startLoading() {
        errorPanel.isHidden = true
        spinner.startAnimating()
    }

    private func showError() {
        webView.isHidden = true
        spinner.stopAnimating()
        errorPanel.isHidden = false
        updateNavigation()
    }

    private func updateNavigation() {
        if requestedURL.host == Self.policyURL.host {
            let button = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain,
                                         target: self, action: #selector(goBack))
            button.accessibilityLabel = "Back to Pastebin"
            navigationItem.rightBarButtonItem = button
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open policy", style: .plain,
                                                               target: self, action: #selector(openPolicy))
        }
    }

    @objc private func openPolicy() {
        requestedURL = Self.policyURL
        updateNavigation()
        loadPage()
    }

    @objc private func close() { dismiss(animated: true) }

    @objc private func goBack() {
        if errorPanel.isHidden, webView.canGoBack {
            webView.goBack()
        } else {
            requestedURL = Self.pasteURL
            updateNavigation()
            loadPage()
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startLoading()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
        spinner.stopAnimating()
        updateNavigation()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if (error as? URLError)?.code != .cancelled { showError() }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if (error as? URLError)?.code != .cancelled { showError() }
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) { showError() }

    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard action.targetFrame?.isMainFrame != false else {
            decisionHandler(.allow)
            return
        }
        guard let url = action.request.url, url.scheme == "https",
              let host = url.host, Self.allowedHosts.contains(host.lowercased()) else {
            decisionHandler(.cancel)
            return
        }
        requestedURL = url
        updateNavigation()
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor response: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if response.isForMainFrame, let http = response.response as? HTTPURLResponse, http.statusCode >= 400 {
            decisionHandler(.cancel)
            showError()
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if action.targetFrame == nil { webView.load(action.request) }
        return nil
    }
}
