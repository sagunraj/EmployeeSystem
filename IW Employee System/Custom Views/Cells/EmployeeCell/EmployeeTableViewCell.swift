
//
//  EmployeeTableViewCell.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 7/1/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var avatar: UILabel!
    
    var employee: Employee? = nil {
        didSet {
            configureEmployee()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureEmployee() {
        name.text = employee?.name
        phone.text = employee?.primaryNumber
        avatar.text = String(employee?.name.prefix(1) ?? "N/A")
    }
    
}
