//
//  stockTableViewCell.swift
//  StockApp
//
//  Created by Field Employee on 12/8/20.
//

import UIKit

class stockTableViewCell: UITableViewCell {

    @IBOutlet weak var companySymbol: UILabel!
    @IBOutlet weak var companyClose: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
