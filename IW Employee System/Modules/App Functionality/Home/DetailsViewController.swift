//
//  DetailsViewController.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/27/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit

//protocol EmployeeProtocol: class {
//    func didUpdateEmployee(employee: Employee, at row: Int)
//    func didAddEmployee(employee: Employee)
//}

//extension EmployeeProtocol { // for making the functions optional
//    func didUpdateEmployee(employee: Employee, at row: Int) {}
//    func didAddEmployee(employee: Employee) {}
//}

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var designation: UITextField!
    @IBOutlet weak var team: UITextField!
    @IBOutlet weak var size: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var employee: Employee?
    private var activityIndicator: UIActivityIndicatorView!
    
    private let numberOfItemsInColumn = 3
    private var projects: [Project] = []
    private var employeeRow: Int = -1
    
    private var pickerView: UIPickerView?
    private var datePicker: UIDatePicker?
    private var imagePicker: UIImagePickerController?
    
    var currentRow: Int = 0
    var activeTextField: UITextField!
    
//    weak var delegate: EmployeeProtocol?
    
    private let designationItems = ["Developer", "Engineering Manager", "Project Manager", "Trainee"]
    private let teamItems = ["ASP.NET", "Mobile", "PHP", "Python"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        
        navigationItem.title = StringConstants.strings["employeeDetails"]
        setupPickerView()
        
        designation.delegate = self
        team.delegate = self
        dob.delegate = self
        
        activityIndicator = UIActivityIndicatorView(style: .gray)
//        activityIndicator.center = CGPoint(x: collectionView.frame.midX, y: collectionView.frame.origin.y + collectionView.bounds.midY) // with respect to the whole view
        activityIndicator.center = collectionView.center
        collectionView.addSubview(activityIndicator)
        
        loadData()
        setupCollectionView()
    }
    
    private func setupPickerView(){
        pickerView = UIPickerView()
        
        pickerView?.dataSource = self
        pickerView?.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pickerDoneTapped))
        toolbar.setItems([doneButton], animated: true)
        
        designation.inputAccessoryView = toolbar
        designation.inputView = pickerView
        
        team.inputAccessoryView = toolbar
        team.inputView = pickerView
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = UIDatePicker.Mode.date
        dob.inputAccessoryView = toolbar
        dob.inputView = datePicker
    }
    
    @objc func pickerDoneTapped(){
        if designation.isFirstResponder {
            designation.text = designationItems[currentRow]
        }
        else if team.isFirstResponder {
            team.text = teamItems[currentRow]
        }
        else if dob.isFirstResponder, let newDate = datePicker?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let selectedDate = dateFormatter.string(from: newDate)
            dob.text = selectedDate
        }
        self.view.endEditing(true)
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
        dob.text = employee?.dob
        if let img = employee?.image {
            imageView.image = UIImage(data: img)
        }
//        if let img = Data(base64Encoded: employee?.image.unWrapped ?? "", options: .ignoreUnknownCharacters) { // FOR BASE64
//            imageView.image = UIImage(data: img)
//        }
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
    
    static func getInstance(with employee: Employee, at row: Int ) -> DetailsViewController? {
        let vc = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        vc?.employee = employee
        vc?.employeeRow = row
        return vc
    }
    
}


// MARK: - <#UICollectionViewDelegate, UICollectionViewDataSource#>
extension DetailsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerView?.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if designation.isFirstResponder {
            return designationItems.count
        }
        else if team.isFirstResponder {
            return teamItems.count
        }
        return 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currentRow = row
        if designation.isFirstResponder {
            return designationItems[row]
        }
        else if team.isFirstResponder {
            return teamItems[row]
        }
        return " "
    }
    
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

extension DetailsViewController {
    
    @IBAction func onTapSaveBtn(_ sender: Any) {
        let imageData = imageView.image?.pngData()
//        let imageData = imageView.image?.pngData()?.base64EncodedString() // FOR BASE64
        
        let changedEmployeeData = Employee(id: (employee?.id).unWrapped,
                                           name: name.text.unWrapped,
                                            emailAddress: email.text.unWrapped,
                                           primaryNumber: phone.text.unWrapped,
                                           designation: designation.text.unWrapped,
                                           team: Team(id: (employee?.team.id)!,
                                                      name: team.text.unWrapped,
                                                      avatar: (employee?.team.avatar).unWrapped,
                                                      members: size.text.unWrapped.intValue),
                                           dob: self.dob.text,
                                           image: imageData
                                        )
        
        let employeeDict = ["employeeDict": changedEmployeeData,
                            "row" : employeeRow ] as [String : Any]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateEmployee"),
                                        object: nil,
                                        userInfo: employeeDict)
//        delegate?.didUpdateEmployee(employee: changedEmployeeData, at: employeeRow)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapChangeImage(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Upload image", preferredStyle: .actionSheet)
        
        let galleryUploadAction = UIAlertAction(title: "Choose from Camera Roll", style: .default, handler: { _ in return self.launchImagePicker() })
        let cameraLaunchAction = UIAlertAction(title: "Launch Camera", style: .default, handler: {_ in return self.launchCamera()})
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in return})
        
        alertController.addAction(galleryUploadAction)
        alertController.addAction(cameraLaunchAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func launchCamera() {
        imagePicker?.sourceType = .camera
        imagePicker?.allowsEditing = true
        present(imagePicker!, animated: true, completion: nil)
    }
    
    private func launchImagePicker() {
        imagePicker?.allowsEditing = true
        imagePicker?.sourceType = .photoLibrary
        
        present(imagePicker!, animated: true, completion: nil)
    }
    
}


// MARK: - <#UINavigationControllerDelegate, UIImagePickerControllerDelegate#>
extension DetailsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
