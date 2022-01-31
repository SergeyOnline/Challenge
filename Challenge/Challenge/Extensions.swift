//
//  Extensions.swift
//  Challenge
//
//  Created by Сергей on 27.01.2022.
//

import UIKit

extension UIView {
	class func initFromNib<T: UIView>() -> T {
		return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as! T
	}
}

extension Bundle {
	
	var apiURL: String {
		return object(forInfoDictionaryKey: "API URL") as? String ?? ""
	}
}
