//
//  TwitTableViewCell.swift
//  Challenge
//
//  Created by Сергей on 28.01.2022.
//

import UIKit

final class TwitTableViewCell: UITableViewCell {

	@IBOutlet weak var twitTextView: UITextView!
	@IBOutlet weak var retweetCountLabel: UILabel!
	@IBOutlet weak var favoriteCountLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var loadedImageView: UIImageView!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		loadedImageView.image = nil
		loadedImageView.isHidden = true
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
