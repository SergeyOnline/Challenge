//
//  ErrorView.swift
//  Challenge
//
//  Created by Сергей on 27.01.2022.
//

import UIKit

final class ErrorView: UIView {

	@IBOutlet weak var descriptionLabel: UILabel!
	
	@IBOutlet weak var reloadButton: UIButton!
	
	public var reloadButtonClosure: (() -> ())?
	
	static func initial() -> ErrorView {
		let view: ErrorView = initFromNib()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.reloadButton.layer.cornerRadius = 10
		return view
	}
	
	@IBAction func reloadButtonAction(_ sender: UIButton) {
		reloadButtonClosure?()
	}
	
	
}
