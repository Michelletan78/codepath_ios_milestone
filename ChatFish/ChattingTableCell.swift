//
//  ChattingTableCell.swift
//  ChatFish
//
//  Created by apple on 25/10/2022.
//

import UIKit

class ChattingTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // text
    
   // @IBOutlet weak var recieverImg: UIImageView!
    @IBOutlet weak var recieverBGView: UIView!
    @IBOutlet weak var recieverMsgLbl: UILabel!
    @IBOutlet weak var recieverDateLbl: UILabel!
   // @IBOutlet weak var recieverArrowImg: UIImageView!
    
   // @IBOutlet weak var senderImg: UIImageView!
    @IBOutlet weak var senderBGView: UIView!
    @IBOutlet weak var senderMsgLbl: UILabel!
    @IBOutlet weak var senderDateLbl: UILabel!
   // @IBOutlet weak var senderArrowImg: UIImageView!
   // @IBOutlet weak var statusImg: UIImageView!
    
    
    
    @IBOutlet weak var senderTxtStack: UIStackView!
    @IBOutlet weak var recieverTxtStack: UIStackView!
    
}
