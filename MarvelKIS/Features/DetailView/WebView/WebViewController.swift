//
//  WebViewController.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/09.
//
import WebKit
import RxCocoa
import RxSwift

class WebViewController: ViewController {
    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var viewContainer: UIView!
    private var wkwebview: WKWebView?
    private var urlRequest: URLRequest?

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? WebViewModel else { return }
        let _ = viewModel.transform()
        if let url = URL(string: viewModel.urlString + MarvelAPIClient.shared.urlParameters()) {
            urlRequest = URLRequest.init(url: url)
        }
        createWkWebView()
    }

    private func createWkWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = false
        configuration.mediaTypesRequiringUserActionForPlayback = .all
        wkwebview = WKWebView(frame: .zero, configuration: configuration)
        guard let wkwebview = wkwebview else { return }
        wkwebview.translatesAutoresizingMaskIntoConstraints = false
        wkwebview.navigationDelegate = self
        viewContainer.addSubview(wkwebview)
        NSLayoutConstraint.activate([
            wkwebview.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            wkwebview.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor),
            wkwebview.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            wkwebview.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor)
        ])
        wkWebViewLoad()
    }

    private func wkWebViewLoad() {
        guard let urlRequest = urlRequest else { return }
        wkwebview?.load(urlRequest)
    }

    private func indicatorStart() {
        indicatorView.isHidden = false
        indicator.startAnimating()
    }

    private func indicatorStop() {
        indicatorView.isHidden = true
        indicator.stopAnimating()
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicatorStart()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorStop()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    {
        indicatorStop()
    }
}
