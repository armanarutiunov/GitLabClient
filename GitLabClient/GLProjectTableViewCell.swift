//
//  GLProjectTableViewCell.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 31/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import UIKit

class GLProjectTableViewCell: UITableViewCell {
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var projectName: UILabel!
	@IBOutlet weak var projectDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
