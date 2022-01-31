//
//  ModuleAssembly.swift
//  Challenge
//
//  Created by Сергей on 30.01.2022.
//

import UIKit

protocol Assembly {
	static func createMainTwitterModule() -> UIViewController
}

final class ModuleAssembly: Assembly {
	static func createMainTwitterModule() -> UIViewController {
		let view = MainTwitterViewController()
		let networkService = NetworkService()
		let presenter = MainTwitterPresenter(view: view, networkService: networkService)
		view.presenter = presenter
		return view
	}
	
}
