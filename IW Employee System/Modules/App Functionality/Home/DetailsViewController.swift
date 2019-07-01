//
//  DetailsViewController.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/27/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var team: UILabel!
    @IBOutlet weak var size: UILabel!
    
    
    var employee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = StringConstants.strings["employeeDetails"]
        
        loadData()
    }
    
    private func loadData(){
        name.text = employee?.name
        email.text = employee?.emailAddress
        phone.text = employee?.primaryNumber
        designation.text = employee?.designation != "" ? employee?.designation : "N/A"
        team.text = employee?.team.name
        size.text = String(employee?.team.members ?? 0)
    }
    
    static func getInstance() -> DetailsViewController? {
        return UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
    }
}
