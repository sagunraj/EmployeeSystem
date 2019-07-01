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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var employee: Employee?
    var activityIndicator: UIActivityIndicatorView!
    
    private let numberOfItemsInColumn = 3
    private var projects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = StringConstants.strings["employeeDetails"]
        
        activityIndicator = UIActivityIndicatorView(style: .gray)
//        activityIndicator.center = CGPoint(x: collectionView.frame.midX, y: collectionView.frame.origin.y + collectionView.bounds.midY) // with respect to the whole view
        activityIndicator.center = collectionView.center
        collectionView.addSubview(activityIndicator)
        
        loadData()
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "EmployeeCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "EmployeeCollectionViewCell")
    }
    
    private func loadData(){
        name.text = employee?.name
        email.text = employee?.emailAddress
        phone.text = employee?.primaryNumber
        designation.text = employee?.designation != "" ? employee?.designation : "N/A"
        team.text = employee?.team.name
        size.text = String(employee?.team.members ?? 0)
        
        loadProjects()
    }
    
    private func loadProjects(){
        activityIndicator.startAnimating()
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        guard let url = URL(string: "https://jsonblob.com/api/f319d773-9bdf-11e9-88d8-f33de0f05ac3") else { return }
        let task = session.dataTask(with: url) {
            (data, response, error) in
            guard let resData = data, response != nil, error == nil else { return }
            let decoder = JSONDecoder()
            do {
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseObj = try decoder.decode(ProjectListResponse.self, from: resData)
                self.projects = responseObj.projects
                let queue = OperationQueue.main
                queue.addOperation {
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            } catch {
                print("Something has gone wrong.")
            }
        }
        task.resume()
    }
    
    static func getInstance() -> DetailsViewController? {
        return UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
    }
}


// MARK: - <#UICollectionViewDelegate, UICollectionViewDataSource#>
extension DetailsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
        return projects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmployeeCollectionViewCell", for: indexPath) as? EmployeeCollectionViewCell
        cell?.project = projects[indexPath.row]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let width = (collectionView.frame.size.width / CGFloat(numberOfItemsInColumn)) - (padding * (CGFloat(numberOfItemsInColumn) - 1))
        return CGSize(width: width, height: width)
    }
    
}
