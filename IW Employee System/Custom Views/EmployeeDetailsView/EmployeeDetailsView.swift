//
//  EmployeeDetailsView.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 7/12/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit

class EmployeeDetailsView: UIView {

    @IBOutlet var contentView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var name: AppTextField!
    @IBOutlet weak var email: AppTextField!
    @IBOutlet weak var phone: AppTextField!
    @IBOutlet weak var designation: AppTextField!
    @IBOutlet weak var team: AppTextField!
    @IBOutlet weak var teamSize: AppTextField!
    @IBOutlet weak var dob: AppTextField!
    @IBOutlet weak var address: UILabel!
    
    var formFields: NSMutableArray = []
    
    private var pickerView: UIPickerView?
    private var datePicker: UIDatePicker?
    
    private let designationItems = ["Developer", "Engineering Manager", "Project Manager", "Trainee"]
    private let teamItems = ["ASP.NET", "Mobile", "PHP", "Python"]
    var currentRow: Int = 0
    
    var employee: Employee? = nil {
        didSet {
            configureEmployee()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("EmployeeDetailsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        getFormFields(formView: self)
        setUpTextField()
        setupPickerView()
    }
    
    private func setUpTextField() {
        name.fieldType = .normal
        dob.canBeEmpty = false
        dob.descriptionTxt = "Date of birth"
    }
    
    private func configureEmployee() {
            name.text = employee?.name
            email.text = employee?.emailAddress
            phone.text = employee?.primaryNumber
            designation.text = employee?.designation != "" ? employee?.designation : "N/A"
            team.text = employee?.team.name
            teamSize.text = String(employee?.team.members ?? 0)
            dob.text = employee?.dob
            address.text = employee?.address?.formattedAddress
    }
    
    func addDelegates(delegate: UITextFieldDelegate) {
        name.delegate = delegate
        email.delegate = delegate
        phone.delegate = delegate
        designation.delegate = delegate
        team.delegate = delegate
        teamSize.delegate = delegate
        dob.delegate = delegate
    }
    
    func reloadTextFieldInputView() {
        pickerView?.reloadAllComponents()
    }
    
    func getChangedEmployeeData() -> Employee {
        return Employee(id: (self.employee?.id).unWrapped,
                 name: self.name.text.unWrapped,
                 emailAddress: self.email.text.unWrapped,
                 primaryNumber: self.phone.text.unWrapped,
                 designation: self.designation.text.unWrapped,
                 team: Team(id: (self.employee?.team.id)!,
                            name: self.team.text.unWrapped,
                            avatar: (self.employee?.team.avatar).unWrapped,
                            members: self.teamSize.text.unWrapped.intValue),
                 dob: self.dob.text)
        
    }
    
    func getFormError() -> String? {
        
        for field in formFields {
            if let formField = field as? AppTextField {
                if !formField.canBeEmpty {
                    if formField.text.unWrapped.isEmpty {
                        return "\(formField.descriptionTxt) field can not be empty"
                    }
                }
            }
        }
        return nil
    }
    
    func getFormFields(formView: UIView) {
        for view in formView.subviews {
            if (view is UITextField || view is UITextView) && view.isUserInteractionEnabled {
                formFields.add(view)
            }
            getFormFields(formView: view)
        }
    }
    
    private func setupPickerView(){
        pickerView = UIPickerView()
        pickerView?.dataSource = self
        pickerView?.delegate = self
        
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = UIDatePicker.Mode.date
        
        designation.inputView = pickerView
        team.inputView = pickerView
        dob.inputView = datePicker
        dob.inputAccessoryView = datePicker
    }
    
     func pickerDoneTapped(){
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
        self.endEditing(true)
    }
    
}

extension EmployeeDetailsView: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
}
