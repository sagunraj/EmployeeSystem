//
//  UIViewControllerExtension.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/26/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(alertTitle:String, alertMessage: String, alertActionTitle: String, handler: @escaping (UIAlertAction) -> Void) {
        
        let alertController = UIAlertController(title: alertTitle,
                                                message: alertMessage,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: alertActionTitle, style: .default, handler: handler)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
     }
    
    
    func showAlert(alertTitle:String,
                   withMessage message: String,
                   okTitle: String = "Yes", okHandler: @escaping () -> Void,
                   cancelTitle: String = "Cancel") {
        
        let alertController = UIAlertController(title: alertTitle,
                                                message: message,
                                                preferredStyle: .alert)
        let okHandler = UIAlertAction(title: okTitle, style: .default) { (handler) in
            okHandler()
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { _ in return
        }
        
        alertController.addAction(okHandler)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}
