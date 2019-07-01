//
//  HomeViewController.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/27/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var employees: [Employee] = []
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        setUpTableView()
        loadDataFromAPI()
    }
    
    private func loadDataFromAPI(){
        activityIndicator.startAnimating()

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        guard let url = URL(string: "https://jsonblob.com/api/ed147871-98a8-11e9-8506-cba44b096bad") else { return }
        let task = session.dataTask(with: url) {
            (data, response, error) in
            guard let resData = data,
                error == nil,
                response != nil else { return }
            let decoder = JSONDecoder()
            do {
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseObj = try decoder.decode(EmployeeListResponse.self, from: resData)
                self.employees = responseObj.employees // store all the data from employees array to employees variable of this class
                let queue = OperationQueue.main
                queue.addOperation {
                    self.activityIndicator.stopAnimating()
//                    self.activityIndicator.isHidden = true
                    self.tableView.reloadData() // reload the tableView
                }
            } catch {
                print("Something has gone wrong.")
            }
        }
        task.resume()
    }
    
    private func setUpTableView() {
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = tableView.center
        view.addSubview(activityIndicator)

        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), // register EmployeeTableViewCell nib to this UITableViewController
                           forCellReuseIdentifier: "EmployeeTableViewCell")
    }
    
}


// MARK: - <#UITableViewDataSource, UITableViewDelegate#>
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as? EmployeeTableViewCell
        cell?.employee = employees[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailsVC = DetailsViewController.getInstance()
        detailsVC?.employee = employees[indexPath.row]
        
        self.navigationController?.pushViewController(detailsVC!, animated: true)
    }
    
}
