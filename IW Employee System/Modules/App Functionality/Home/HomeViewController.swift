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
    @IBOutlet weak var user: UILabel!
    
    private var employees: [Employee] = []
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        loadDataFromAPI()
        
        let userData = UserDefaultsHelper.getUserDefaults(for: User.self, forKey: Constants.UserDefaultKeys.userInfo)
        user.text = "Hello \(userData?.firstName ?? "user")!"
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
        navigationItem.title = StringConstants.strings["employeeList"]

        tableView.tableFooterView = UIView()

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
extension HomeViewController: UITableViewDataSource, UITableViewDelegate, EmployeeProtocol, EmployeeCellProtocol {
    
    func onEmployeeDelete(cell: EmployeeTableViewCell) {
//        let filteredEmployee = employees.filter {
//           (item) in
//                item.id != cell.employee?.id
//        }
//        employees = filteredEmployee
//        OR
//        if let index = employees.firstIndex(where: { (employee) -> Bool in
//            return employee.id == (cell.employee?.id ?? -1)
//        }) {
//            employees.remove(at: index)
//        }
//        tableView.reloadData()

        showAlert(alertTitle: "Are you sure you want to delete?",
                  withMessage: "This action cannot be undone.",
                  okHandler: { () in self.deleteAction(cell: cell) })

    }
    
    private func deleteAction(cell: EmployeeTableViewCell){
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        employees.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func didUpdateEmployee(employee: Employee, at row: Int) {
        employees[row] = employee
        
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as? EmployeeTableViewCell
        cell?.employee = employees[indexPath.row]
        cell?.delegate = self
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = DetailsViewController.getInstance(with: employees[indexPath.row], at: indexPath.row)
        detailsVC?.delegate = self
        navigationController?.pushViewController(detailsVC!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) as? EmployeeTableViewCell else { return }
//        showAlert(alertTitle: "Are you sure you want to delete?",
//                  withMessage: "This action cannot be undone.",
//                  okHandler: { () in self.deleteAction(cell: cell) })
//    }
//
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let details = UITableViewRowAction(style: .normal, title: "Details", handler: {(action, index) in
            let detailsVC = DetailsViewController.getInstance(with: self.employees[indexPath.row], at: indexPath.row)
            detailsVC?.delegate = self
            self.navigationController?.pushViewController(detailsVC!, animated: true)
        })
        details.backgroundColor = .orange
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, index) in
            guard let cell = tableView.cellForRow(at: indexPath) as? EmployeeTableViewCell else { return }
            self.showAlert(alertTitle: "Are you sure you want to delete?",
                      withMessage: "This action cannot be undone.",
                      okHandler: { () in self.deleteAction(cell: cell) })
        })
        delete.backgroundColor = .red
        
        return [details, delete]
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let details = UIContextualAction(style: .normal, title: "Details", handler: {(action, index, arg)  in
            let detailsVC = DetailsViewController.getInstance(with: self.employees[indexPath.row], at: indexPath.row)
            detailsVC?.delegate = self
            self.navigationController?.pushViewController(detailsVC!, animated: true)
        })
        details.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [details])
    }
    
    
}


