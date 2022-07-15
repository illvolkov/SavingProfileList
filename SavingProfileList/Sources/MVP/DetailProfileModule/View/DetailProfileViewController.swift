//
//  DetailProfileViewController.swift
//  SavingProfileList
//
//  Created by Ilya Volkov on 12.07.2022.
//

import Foundation
import UIKit
import PhotosUI

final class DetailProfileViewController: UIViewController {
    
    //MARK: - References
    
    public var presenter: DetailProfilePresenter?
    
//    //MARK: - Const

    let genders = ["Male",
                   "Female",
                   "Lesbian",
                   "Gay",
                   "Bisexual",
                   "Transgender",
                   "Agender",
                   "Androgyne",
                   "Bigender",
                   "Cis male",
                   "Cis female",
                   "FTM",
                   "MTF",
                   "Gender Fluid",
                   "Gender Nonconforming",
                   "Gender Questioning",
                   "Gender Variant",
                   "Genderqueer",
                   "Neutrois",
                   "Non-binary",
                   "Other",
                   "Pangender",
                   "Two-spirit",
                   "Anongender",
                   "Cavusgender",
                   "Zodiacgender",
                   "Aesthetgender",
                   "Affectugender",
                   "Digigender",
                   "Egogender"]
    
    //MARK: - Variables
    
    private var selectedProfile: Profile?
    private var isKeyboardPresent = false
    
    public var isEditButton: Bool = false {
        didSet {
            if isEditButton {
                editModeIsActive()
            } else {
                guard let presenter = presenter else { return }

                if (nameField.text?.count ?? 0) < 3 || (nameField.text?.count ?? 0) > 16 {
                    presenter.presentInvalidNumberAlert()
                    return
                } else {
                    editModeInactive()
                    saveProfileData()
                }
            }
        }
    }
        
    //MARK: - Initial
    
    public init(selectedProfile: Profile) {
        self.selectedProfile = selectedProfile
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError()
    }
    
    private func commonInit() {

        if let name = selectedProfile?.name {
            nameField.text = name
        }
        if let gender = selectedProfile?.gender {
            genderField.text = gender
        }
        if let birthday = selectedProfile?.birthday {
            getDateFromPicker(with: birthday)
        }
        if let userpic = selectedProfile?.userpic {
            profileImage.image = UIImage(data: userpic)
        }
    }
    
    //MARK: - Views
    
    private lazy var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "gradient.back")
        return backgroundImage
    }()
    
    private lazy var topBarHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: view.frame.width * 0.08, weight: .light)
        let image = UIImage(systemName: "xmark.app", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveEditButton: UIButton = {
        let button = UIButton()
        
        if let titleLabel = button.titleLabel {
            titleLabel.textColor = .white
            titleLabel.font = .systemFont(ofSize: view.frame.width * 0.045)
        }
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(saveEditButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "empty.avatar")
        profileImage.layer.cornerRadius = view.frame.width * 0.2
        profileImage.layer.masksToBounds = true
        profileImage.layer.contentsRect = CGRect(x: profileImage.frame.origin.x + 0.06,
                                                 y: profileImage.frame.origin.y + 0.06,
                                                 width: 0.88,
                                                 height: 0.88)
        return profileImage
    }()
    
    private lazy var addUserpicButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: view.frame.width * 0.35)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .lightGray
        button.alpha = 0.5
        button.addTarget(self, action: #selector(addUserpicButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameFieldDivider = createDivider()
    private lazy var birthdayFieldDivider = createDivider()
    private lazy var genderFieldDivider = createDivider()
        
    private lazy var nameField: UITextField = {
        let textField = UITextField()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 18))
        let icon = UIImage(systemName: "person.fill")
        textField.leftViewMode = UITextField.ViewMode.always
        imageView.image = icon
        //for width offset
        view.addSubview(imageView)
        textField.leftView = view
        textField.inputAccessoryView = doneButtonForKeyboard
        
        textField.placeholder = "Name"
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var birthdayField = createPickerField(with: "Birthday", iconSystemName: "calendar", inputView: birthdayPicker)
    private lazy var genderField = createPickerField(with: "Gender", iconSystemName: "allergens", inputView: genderPicker)
    
    private lazy var doneButtonForKeyboard: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTap))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        return toolBar
    }()
    
    private lazy var numberOfCharactersLabel: UILabel = {
        let label = UILabel()
        label.text = "from 3 to 16 characters"
        label.textColor = .white
        label.font = .systemFont(ofSize: view.frame.width * 0.03)
        return label
    }()
    
    private lazy var birthdayPicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(handleBirthdayPicker), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var genderPicker: UIPickerView = {
        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        return genderPicker
    }()
    
    private lazy var lockIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lock.fill")
        imageView.tintColor = .white
        return imageView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editModeInactive()
        addObserversForKeyboard()
        commonInit()
        
        setupHierarchy()
        setupLayout()
        setupView()
    }
    
    //MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(backgroundImage)
        view.addSubview(doneButtonForKeyboard)
        view.addSubview(topBarHStack)
        topBarHStack.addArrangedSubview(dismissButton)
        topBarHStack.addArrangedSubview(saveEditButton)
        view.addSubview(profileImage)
        view.addSubview(addUserpicButton)
        view.addSubview(nameField)
        view.addSubview(nameFieldDivider)
        view.addSubview(numberOfCharactersLabel)
        view.addSubview(birthdayField)
        view.addSubview(birthdayFieldDivider)
        view.addSubview(genderField)
        view.addSubview(genderFieldDivider)
        view.addSubview(lockIcon)
    }
    
    private func setupLayout() {
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        topBarHStack.translatesAutoresizingMaskIntoConstraints = false
        topBarHStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        topBarHStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        topBarHStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).isActive = true
        dismissButton.heightAnchor.constraint(equalTo: dismissButton.widthAnchor).isActive = true
        
        saveEditButton.translatesAutoresizingMaskIntoConstraints = false
        saveEditButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        saveEditButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).isActive = true
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: topBarHStack.bottomAnchor,
                                          constant: adaptationToDifferentScreenSize(withSpecificSize: 40,
                                                                                    andDefaultSize: 80)).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
        
        addUserpicButton.translatesAutoresizingMaskIntoConstraints = false
        addUserpicButton.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
        addUserpicButton.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
        addUserpicButton.widthAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
        addUserpicButton.heightAnchor.constraint(equalTo: profileImage.heightAnchor).isActive = true
        
        lockIcon.translatesAutoresizingMaskIntoConstraints = false
        lockIcon.topAnchor.constraint(equalTo: profileImage.bottomAnchor,
                                      constant: adaptationToDifferentScreenSize(withSpecificSize: 32.5,
                                                                                andDefaultSize: 65)).isActive = true
        lockIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lockIcon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).isActive = true
        lockIcon.heightAnchor.constraint(equalTo: lockIcon.widthAnchor).isActive = true
        
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.topAnchor.constraint(equalTo: lockIcon.bottomAnchor,
                                       constant: adaptationToDifferentScreenSize(withSpecificSize: 32.5,
                                                                                 andDefaultSize: 65)).isActive = true
        nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        nameFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        nameFieldDivider.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 5).isActive = true
        nameFieldDivider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameFieldDivider.widthAnchor.constraint(equalTo: nameField.widthAnchor).isActive = true
        nameFieldDivider.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.001).isActive = true
        
        numberOfCharactersLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfCharactersLabel.topAnchor.constraint(equalTo: nameFieldDivider.bottomAnchor, constant: 5).isActive = true
        numberOfCharactersLabel.leftAnchor.constraint(equalTo: nameFieldDivider.leftAnchor).isActive = true
        
        birthdayField.translatesAutoresizingMaskIntoConstraints = false
        birthdayField.topAnchor.constraint(equalTo: nameFieldDivider.bottomAnchor,
                                           constant: adaptationToDifferentScreenSize(withSpecificSize: 30,
                                                                                     andDefaultSize: 40)).isActive = true
        birthdayField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        birthdayField.widthAnchor.constraint(equalTo: nameField.widthAnchor).isActive = true
        
        birthdayFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        birthdayFieldDivider.topAnchor.constraint(equalTo: birthdayField.bottomAnchor, constant: 5).isActive = true
        birthdayFieldDivider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        birthdayFieldDivider.widthAnchor.constraint(equalTo: nameFieldDivider.widthAnchor).isActive = true
        birthdayFieldDivider.heightAnchor.constraint(equalTo: nameFieldDivider.heightAnchor).isActive = true
        
        genderField.translatesAutoresizingMaskIntoConstraints = false
        genderField.topAnchor.constraint(equalTo: birthdayField.bottomAnchor,
                                         constant: adaptationToDifferentScreenSize(withSpecificSize: 30,
                                                                                   andDefaultSize: 40)).isActive = true
        genderField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        genderField.widthAnchor.constraint(equalTo: nameField.widthAnchor).isActive = true
        
        genderFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        genderFieldDivider.topAnchor.constraint(equalTo: genderField.bottomAnchor, constant: 5).isActive = true
        genderFieldDivider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        genderFieldDivider.widthAnchor.constraint(equalTo: nameFieldDivider.widthAnchor).isActive = true
        genderFieldDivider.heightAnchor.constraint(equalTo: nameFieldDivider.heightAnchor).isActive = true
    }
    
    private func setupView() {
        title = "Saved profile"
        view.tintColor = .white
    }
    
    //MARK: - Functions
    
    private func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .lightGray
        return divider
    }
    
    private func createPickerField(with placeholder: String, iconSystemName: String, inputView: UIView) -> PickerField {
        let textField = PickerField()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 18))
        let icon = UIImage(systemName: iconSystemName)
        textField.leftViewMode = UITextField.ViewMode.always
        imageView.image = icon
        //view to indent icon from textfield
        view.addSubview(imageView)
        textField.leftView = view
        textField.inputAccessoryView = doneButtonForKeyboard
        textField.inputView = inputView
        
        textField.placeholder = placeholder
        textField.clearButtonMode = .whileEditing
        return textField
    }
    
    private func addObserversForKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }
    
    private func editModeInactive() {
        saveEditButton.setTitle("Edit", for: .normal)
        lockIcon.image = UIImage(systemName: "lock.fill")
        addUserpicButton.isHidden = true
        numberOfCharactersLabel.isHidden = true
        nameField.isUserInteractionEnabled = false
        birthdayField.isUserInteractionEnabled = false
        genderField.isUserInteractionEnabled = false
    }

    private func editModeIsActive() {
        saveEditButton.setTitle("Save", for: .normal)
        lockIcon.image = UIImage(systemName: "lock.open.fill")
        addUserpicButton.isHidden = false
        nameField.isUserInteractionEnabled = true
        birthdayField.isUserInteractionEnabled = true
        genderField.isUserInteractionEnabled = true
    }
    
    private func getDateFromPicker(with date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        birthdayField.text = formatter.string(from: date)
    }
    
    private func adaptationToDifferentScreenSize(withSpecificSize: CGFloat, andDefaultSize: CGFloat) -> CGFloat {
        let device = UIDevice()
        if device.name == "iPod touch (7th generation)" ||
            device.name == "iPhone SE (3rd generation)" ||
            device.name == "iPhone 8" ||
            device.name == "iPhone 8 Plus" {
            return withSpecificSize
        } else {
            return andDefaultSize
        }
    }
    
    //MARK: - Actions
    
    @objc private func saveEditButtonDidTap() {
        isEditButton.toggle()
    }
    
    @objc private func addUserpicButtonDidTap() {
        guard let presenter = presenter else { return }
        presenter.addOrDeleteUserpicWithSheet(together: self, imageView: profileImage)
    }
    
    @objc private func dismissButtonDidTap() {
        guard let presenter = presenter else { return }
        
        presenter.dismissDetailProfileViewController()
    }
    
    @objc private func doneButtonDidTap() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        numberOfCharactersLabel.isHidden = false
        
        guard !isKeyboardPresent else { return }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
                isKeyboardPresent = true
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        numberOfCharactersLabel.isHidden = true
        
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
            isKeyboardPresent = false
        }
    }
    
    @objc private func handleBirthdayPicker() {
        getDateFromPicker(with: birthdayPicker.date)
    }
}

//MARK: - DetailProfilePresenterDelegate methods

extension DetailProfileViewController: DetailProfilePresenterDelegate {
    
    public func saveProfileData() {
        
        guard let presenter = presenter,
              let selectedProfile = selectedProfile
        else {
            return
        }
        
        presenter.saveNewProfileData(with: selectedProfile,
                                     newName: nameField.text ?? "",
                                     newBirthday: (birthdayField.text?.isEmpty ?? true) ? nil : birthdayPicker.date,
                                     newGender: genderField.text ?? "",
                                     newUserpic: profileImage.image?.pngData() ?? Data())
    }
}

//MARK: - PHPickerViewControllerDelegate methods

extension DetailProfileViewController: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.profileImage.image = image
                    }
                }
            }
        }
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource methods

extension DetailProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        genders.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        genders[row]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = genders[row]
    }
}
