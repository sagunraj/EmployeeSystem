//
//  DetailsViewController.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/27/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit
import MapKit

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
    @IBOutlet weak var address: UILabel!
    
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
        
        navigationItem.title = StringConstants.strings["employeeDetails"]
        
        setupPickerView()
        
        designation.delegate = self
        team.delegate = self
        dob.delegate = self
        
        activityIndicator = UIActivityIndicatorView(style: .gray)
        //        activityIndicator.center = CGPoint(x: collectionView.frame.midX, y: collectionView.frame.origin.y + collectionView.bounds.midY) // with respect to the whole view
        activityIndicator.center = collectionView.center
        collectionView.addSubview(activityIndicator)
        
        addLocationBarButton()
        
        loadProjects()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func addLocationBarButton(){
        let locationBarButton = UIBarButtonItem(image: UIImage(named: "marker.png"), style: .plain, target: self, action: #selector(navigateToMapView))
        navigationItem.rightBarButtonItem = locationBarButton
    }
    
    @objc private func navigateToMapView(){
        if let emp = employee {
            if let mapVC = MapViewController.getInstance(with: [emp]) as MapViewController? {
                mapVC.delegate = self
                navigationController?.pushViewController(mapVC, animated: true)
            }
        }
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
        address.text = employee?.address?.formattedAddress
        //        if let img = Data(base64Encoded: employee?.image.unWrapped ?? "", options: .ignoreUnknownCharacters) { // FOR BASE64
        //            imageView.image = UIImage(data: img)
        //        }
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
    
    private func formattedAddress(latitude: Double, longitude: Double, onCompletion: @escaping ((String) -> Void)) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude), completionHandler: {
            (placemarks, error) in
            var generatedAddress = ""
            if error == nil {
                if let subLocality = placemarks?[0].subLocality, let locality = placemarks?[0].locality {
                    generatedAddress = "\(subLocality), \(locality), \(placemarks?[0].country ?? "None")"
                }
                else {
                    generatedAddress = "\(placemarks?[0].country.unWrapped ?? "None")"
                }
            } else {
                print("Error while getting formatted address of given coordinates: \(latitude) \(longitude).")
                generatedAddress = "No address generated."
            }
            onCompletion(generatedAddress)
        })
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
        if designation.isFirstResponder || team.isFirstResponder {
            return designation.isFirstResponder ? designationItems.count : teamItems.count
        }
        return  0
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
        
        if let latitude = employee?.address?.latitude, let longitude = employee?.address?.longitude, let formattedAddress = employee?.address?.formattedAddress {
            let changedEmployeeData = Employee(id: (self.employee?.id).unWrapped,
                                               name: self.name.text.unWrapped,
                                               emailAddress: self.email.text.unWrapped,
                                               primaryNumber: self.phone.text.unWrapped,
                                               designation: self.designation.text.unWrapped,
                                               team: Team(id: (self.employee?.team.id)!,
                                                          name: self.team.text.unWrapped,
                                                          avatar: (self.employee?.team.avatar).unWrapped,
                                                          members: self.size.text.unWrapped.intValue),
                                               dob: self.dob.text,
                                               image: imageData,
                                               address: Address(latitude: latitude, longitude: longitude, formattedAddress: formattedAddress)
            )
            
            let employeeDict = ["employeeDict": changedEmployeeData,
                                "row" : self.employeeRow ] as [String : Any]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateEmployee"),
                                            object: nil,
                                            userInfo: employeeDict)
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
        //        delegate?.didUpdateEmployee(employee: changedEmployeeData, at: employeeRow)
    }
    
    @IBAction func onTapChangeImage(_ sender: Any) {
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        
        let alertController = UIAlertController(title: nil, message: "Upload image", preferredStyle: .actionSheet)
        
        let galleryUploadAction = UIAlertAction(title: "Choose from Camera Roll",
                                                style: .default,
                                                handler: { _ in return
                                                    self.pickImage(using: .photoLibrary)
        })
        
        let cameraLaunchAction = UIAlertAction(title: "Launch Camera",
                                               style: .default,
                                               handler: {_ in
                                                return self.pickImage(using: .camera)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in return})
        
        alertController.addAction(galleryUploadAction)
        alertController.addAction(cameraLaunchAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func pickImage(using source:  UIImagePickerController.SourceType) {
        imagePicker?.sourceType = source
        imagePicker?.allowsEditing = true
        present(imagePicker!, animated: true, completion: nil)
    }
    
    
}


// MARK: - <#UINavigationControllerDelegate, UIImagePickerControllerDelegate#>
extension DetailsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - <#MapOperationProtocol#>
extension DetailsViewController: MapOperationProtocol {
    
    func updateEmployeeAddress(coordinates: CLLocationCoordinate2D) {
        self.employee?.address?.latitude = coordinates.latitude
        self.employee?.address?.longitude = coordinates.longitude
        formattedAddress(latitude: coordinates.latitude, longitude: coordinates.longitude) { (address) in
            self.employee?.address?.formattedAddress = address
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
