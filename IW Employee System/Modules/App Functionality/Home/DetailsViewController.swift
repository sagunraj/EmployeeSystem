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

class DetailsViewController: KeyboardAvoidingViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var employeeDetailsView: EmployeeDetailsView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var employee: Employee?
    private var activityIndicator: UIActivityIndicatorView!
    
    private let numberOfItemsInColumn = 3
    private var projects: [Project] = []
    private var employeeRow: Int = -1
    
    private var imagePicker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kaScrollView = scrollView
        setUpNavBar()
        makeActivityIndicator()
        loadProjects()
        setupCollectionView()
        addDelegates()
    }
    
    private func setUpNavBar() {
        navigationItem.title = StringConstants.strings["employeeDetails"]
        addLocationBarButton()
    }
    
    private func addDelegates() {
        employeeDetailsView.addDelegates(delegate: self)
    }
    
    private func makeActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = collectionView.center
        collectionView.addSubview(activityIndicator)
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
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "EmployeeCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "EmployeeCollectionViewCell")
    }
    
    private func loadData(){
        employeeDetailsView.employee = employee
        if let img = employee?.image {
            imageView.image = UIImage(data: img)
        }
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
                generatedAddress = placemarks?.first.unWrapped.formattedAddress ?? ""
            } else {
                print("Error while getting formatted address of given coordinates: \(latitude) \(longitude).")
                generatedAddress = "No address generated."
            }
            onCompletion(generatedAddress)
        })
    }
    
    override func doneButtonTapped(Sender: UIButton) {
        employeeDetailsView.pickerDoneTapped()
        super.doneButtonTapped(Sender: Sender)
    }
    
}

extension DetailsViewController {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        employeeDetailsView.reloadTextFieldInputView()
    }
    
}

// MARK: - <#UICollectionViewDelegate, UICollectionViewDataSource#>
extension DetailsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        
        if let error = employeeDetailsView.getFormError() {
            showAlert(alertMessage: error) { _ in
            }
            return 
        }
        
        let imageData = imageView.image?.pngData()
        
        if let latitude = employee?.address?.latitude,
            let longitude = employee?.address?.longitude,
            let formattedAddress = employee?.address?.formattedAddress {
            var changedEmployeeData = employeeDetailsView.getChangedEmployeeData()
            changedEmployeeData.image = imageData
            changedEmployeeData.address = Address(latitude: latitude, longitude: longitude, formattedAddress: formattedAddress)
            
            let employeeDict = ["employeeDict": changedEmployeeData,
                                "row" : self.employeeRow ] as [String : Any]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateEmployee"),
                                            object: nil,
                                            userInfo: employeeDict)
            
            navigationController?.popViewController(animated: true)
            
        }
        
        // delegate?.didUpdateEmployee(employee: changedEmployeeData, at: employeeRow)
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
