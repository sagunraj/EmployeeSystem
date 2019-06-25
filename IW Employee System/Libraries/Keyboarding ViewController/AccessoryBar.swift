//
//  AccessoryBar.swift
//  Econ Mortgage
//
//  Created by Insight Workshop on 3/22/19.
//  Copyright © 2019 Econ Mortgage. All rights reserved.
//

import UIKit

protocol AccessoryDelegate: class {
    func previousButtonTapped (Sender: UIButton)
    func nextButtonTapped (Sender: UIButton)
    func doneButtonTapped (Sender: UIButton)
}

class AccessoryBar: UIView {

    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!

    weak var barDelegate: AccessoryDelegate?

    @IBAction func previousButtonTapped(sender: UIButton) {
        barDelegate?.previousButtonTapped(Sender: sender)
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        barDelegate?.nextButtonTapped(Sender: sender)
    }
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        barDelegate?.doneButtonTapped(Sender: sender)
    }
    
}
