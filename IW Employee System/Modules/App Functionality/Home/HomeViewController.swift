//
//  HomeViewController.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/27/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension HomeViewController {
    
    @IBAction func onViewDetailsTap(_ sender: UIButton) {
        
        guard let detailsVC = DetailsViewController.getInstance() else { return }
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}
