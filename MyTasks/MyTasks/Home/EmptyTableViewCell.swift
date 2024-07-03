//
//  EmptyTableViewCell.swift
//  MyTasks
//
//  Created by Vishal Kashyap on 03/07/24.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label.text = "No task found."
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
