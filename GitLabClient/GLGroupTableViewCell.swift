//
//  GLGroupTableViewCell.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 31/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import UIKit

class GLGroupTableViewCell: UITableViewCell {

	@IBOutlet weak var groupAvatarImageView: UIImageView!
	@IBOutlet weak var groupName: UILabel!
	@IBOutlet weak var groupDescription: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
