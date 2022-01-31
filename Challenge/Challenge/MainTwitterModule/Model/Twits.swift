//
//  Twits.swift
//  Challenge
//
//  Created by Сергей on 28.01.2022.
//

import Foundation

struct Twits: Decodable {
	let status: Bool
	let data: [TwitData]
		
		private enum CodingKeys: String, CodingKey {
			case status = "success"
			case data
		}
}

struct TwitData: Decodable {
	let id: Int
	let text: String
	let createdAt: Double
	let retweetCount: Int
	let favoriteCount: Int
	let imageURL: String?
}
