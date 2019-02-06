//
//  NewsTableCell.swift
//  PropertyList
//
//  Created by Ivan Ermak on 12/13/18.
//  Copyright © 2018 Ivan Ermak. All rights reserved.
//

import UIKit

class NewsPrototypeCell : UITableViewCell
{
    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var value: UITextView!
    @IBOutlet weak var images: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        key.text = ""
        value.text = ""
        images.image = UIImage()
    }
    
    
}

