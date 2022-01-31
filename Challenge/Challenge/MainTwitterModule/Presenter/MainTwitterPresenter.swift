//
//  MainTwitterPresenter.swift
//  Challenge
//
//  Created by Сергей on 30.01.2022.
//

import Foundation
import UIKit

protocol IMainTwitterPresenter: AnyObject {
	init(view: IMainTwitterViewController, networkService: NetworkServiceProtocol)
	func changeState()
	func getImageFromUrl(url: String, completion: @escaping (UIImage?) -> ())
}

protocol IMainTwitterViewController: AnyObject {
	var props: MainTwitterViewController.Props { get set }
}

final class MainTwitterPresenter: IMainTwitterPresenter {
	
	private enum DateFormat {
		static let hourAndMinute = "HH:mm"
		static let dayAndMonth = "d MMMM yyyy"
	}
	
	weak var view: IMainTwitterViewController?
	let networkService: NetworkServiceProtocol
	
	required init(view: IMainTwitterViewController, networkService: NetworkServiceProtocol) {
		self.view = view
		self.networkService = networkService
		getTwits()
	}
	
	func changeState() {
		getTwits()
	}
	
	func getImageFromUrl(url: String, completion: @escaping (UIImage?) -> ()) {
		guard let url = URL(string: url) else { return }
		networkService.getImageFromURL(url) { image in
			completion(image)
		}
	}
	
//	MARK: - private functions
	private func getTwits() {
		networkService.getTwits { result in
			guard let view = self.view else { return }
			DispatchQueue.main.async {
				switch result {
				case .failure(let error):
					view.props = .error(description: error.localizedDescription)
				case .success(let twits):
					if twits == nil {
						view.props = .error(description: "No data")
					} else {
						view.props = .loaded(self.convertTwitsToProps(twits: twits!))
					}
				}
			}
		}
	}
	
	private func convertTwitsToProps(twits: Twits) -> [MainTwitterViewController.Props.Data] {
		var data: [MainTwitterViewController.Props.Data] = []
		for (i, twit) in twits.data.sorted(by: { $0.createdAt > $1.createdAt }).enumerated() {
			let date  = Date(timeIntervalSince1970: twit.createdAt / 1000)
			var prop: MainTwitterViewController.Props.Data
			
//		MARK: - hardcode image url
			if i == 1 {
				prop = MainTwitterViewController.Props.Data(id:twit.id,
																text: twit.text,
																favoriteCount: String(twit.favoriteCount),
																retweetCount: String(twit.retweetCount),
																date: stringFromDate(date),
																imageURL: "https://guitaristnextdoor.com/wp-content/uploads/2021/04/presenting-6-Best-Guitar-Amps-Under-200-1024x663.png")
			} else {
				prop = MainTwitterViewController.Props.Data(id:twit.id,
																text: twit.text,
																favoriteCount: String(twit.favoriteCount),
																retweetCount: String(twit.retweetCount),
																date: stringFromDate(date),
																imageURL: twit.imageURL)
			}
			
//		MARK: - image url from JSON
//			let prop = MainTwitterViewController.Props.Data(id:twit.id,
//															text: twit.text,
//															favoriteCount: String(twit.favoriteCount),
//															retweetCount: String(twit.retweetCount),
//															date: stringFromDate(date),
//															imageURL: twit.imageURL)
			
			
			
			data.append(prop)
		}
		return data
	}
	
	private func stringFromDate(_ date: Date?) -> String {
		guard let d = date else { return "" }
		let calendar = Calendar(identifier: .gregorian)
		let dateFormatter = DateFormatter()
		if let currentDate = date {
			if calendar.startOfDay(for: currentDate) == calendar.startOfDay(for: Date()) {
				dateFormatter.dateFormat = DateFormat.hourAndMinute
			} else {
				dateFormatter.dateFormat = DateFormat.dayAndMonth
			}
		}
		return dateFormatter.string(from: d)
	}
}
