//
//  EmployeeCollectionViewCell.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 7/1/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit

class EmployeeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var project: Project? = nil {
        didSet {
            configureProject()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func configureProject(){
        if let image = project?.image {
            loadImage(image)
        }
        name.text = project?.name
    }
    
    private func loadImage(_ image: String){
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        guard let url = URL(string: image) else { return }
        let task = session.dataTask(with: url) {
            (data, response, error) in
            guard let resData = data, error == nil, response != nil else { return }
            DispatchQueue.main.async {
                self.image.image = UIImage(data: resData)
                
            }
        }
        task.resume()
    }
}
