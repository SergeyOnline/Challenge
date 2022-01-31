//
//  LoadingView.swift
//  Challenge
//
//  Created by Сергей on 27.01.2022.
//

import UIKit

final class LoadingView: UIView {

	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	static func initial() -> LoadingView {
		let view: LoadingView = initFromNib()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}

}
