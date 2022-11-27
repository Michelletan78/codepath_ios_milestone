//
//  chatListCell.swift
//  ChatFish
//
//  Created by apple on 25/10/2022.
//

import UIKit
import FirebaseFirestore

class chatListCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
