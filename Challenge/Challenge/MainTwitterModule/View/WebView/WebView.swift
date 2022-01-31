//
//  WebView.swift
//  Challenge
//
//  Created by Сергей on 31.01.2022.
//

import UIKit
import WebKit

class WebView: UIView {

	@IBOutlet weak var webView: WKWebView!
	
	public var readyButtonClosure: (() -> ())?
	
	static func initial() -> WebView {
		let view: WebView = initFromNib()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}
	@IBAction func readyButtonAction(_ sender: UIButton) {
		readyButtonClosure?()
	}
	
}
