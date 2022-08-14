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
    
    //MARK: - Const

    let genders = Sequences.gendersList
    
    //MARK: - Variables
    
    private var selectedProfile: Profile?
    private var isKeyboardPresent = false
    
    public var isEditButton: Bool = false {
        didSet {
            if isEditButton {
                editModeIsActive()
            } else {
                saveProfileData()
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
        backgroundImage.image = UIImage(named: Images.backgroundImage)
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
        let config = UIImage.SymbolConfiguration(pointSize: view.frame.width * Sizes.dismissButtomImageSize, weight: .light)
        let image = UIImage(systemName: Images.dismissButtonImage, withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveEditButton: UIButton = {
        let button = UIButton()
        
        if let titleLabel = button.titleLabel {
            titleLabel.textColor = .white
            titleLabel.font = .systemFont(ofSize: view.frame.width * Sizes.fontSize0_045)
        }
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = Sizes.borderWidth2
        button.addTarget(self, action: #selector(saveEditButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: Images.emptyAvatarImage)
        profileImage.layer.cornerRadius = view.frame.width * Sizes.profileImageCornerRadius
        profileImage.layer.masksToBounds = true
        profileImage.layer.contentsRect = CGRect(x: profileImage.frame.origin.x + Offsets.profileImageXYBoundsOffset0_06,
                                                 y: profileImage.frame.origin.y + Offsets.profileImageXYBoundsOffset0_06,
                                                 width: Offsets.profileImageWidthHeightOffset0_88,
                                                 height: Offsets.profileImageWidthHeightOffset0_88)
        return profileImage
    }()
    
    private lazy var addUserpicButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: view.frame.width * Sizes.addUserpicButtonImageSize)
        let image = UIImage(systemName: Images.addUserpicButtonImage, withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .lightGray
        button.alpha = Display.addUserpicButtonAlpha
        button.addTarget(self, action: #selector(addUserpicButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameFieldDivider = createDivider()
    private lazy var birthdayFieldDivider = createDivider()
    private lazy var genderFieldDivider = createDivider()
        
    private lazy var nameField: UITextField = {
        let textField = UITextField()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Sizes.widthSize18, height: Sizes.heightSize18))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Sizes.viewWidthSize, height: Sizes.heightSize18))
        let icon = UIImage(systemName: Images.nameFieldImages)
        textField.leftViewMode = UITextField.ViewMode.always
        imageView.image = icon
        //view to indent icon from textfield
        view.addSubview(imageView)
        textField.leftView = view
        textField.inputAccessoryView = doneButtonForKeyboard
        
        textField.placeholder = Strings.nameFieldPlaceholderName
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var birthdayField = createPickerField(with: Strings.birthdayFieldPlaceholder,
                                                       iconSystemName: Images.birthdayFieldImage,
                                                       inputView: birthdayPicker)
    private lazy var genderField = createPickerField(with: Strings.genderFieldPlaceholder,
                                                     iconSystemName: Images.genderFieldImage,
                                                     inputView: genderPicker)
    
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
        label.text = Strings.numberOfCharactersLabelText
        label.textColor = .white
        label.font = .systemFont(ofSize: view.frame.width * Sizes.numberOfCharactersLabelFontSize)
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
        imageView.image = UIImage(systemName: Images.lockImage)
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
        topBarHStack.topAnchor.constraint(equalTo: view.topAnchor, constant: Offsets.topBottomOffset80).isActive = true
        topBarHStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Offsets.topBarHStackLeftOffset).isActive = true
        topBarHStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Offsets.topBarHStackRightOffset).isActive = true
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.heightWidthSize0_1).isActive = true
        dismissButton.heightAnchor.constraint(equalTo: dismissButton.widthAnchor).isActive = true
        
        saveEditButton.translatesAutoresizingMaskIntoConstraints = false
        saveEditButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.widthSize0_2).isActive = true
        saveEditButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.heightWidthSize0_1).isActive = true
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: topBarHStack.bottomAnchor,
                                          constant: adaptationToDifferentScreenSize(withSpecificSize: Offsets.topBarHStackBottomSpecificOffset,
                                                                                    andDefaultSize: Offsets.topBottomOffset80)).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.profileImageWidthSize).isActive = true
        profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
        
        addUserpicButton.translatesAutoresizingMaskIntoConstraints = false
        addUserpicButton.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
        addUserpicButton.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
        addUserpicButton.widthAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
        addUserpicButton.heightAnchor.constraint(equalTo: profileImage.heightAnchor).isActive = true
        
        lockIcon.translatesAutoresizingMaskIntoConstraints = false
        lockIcon.topAnchor.constraint(equalTo: profileImage.bottomAnchor,
                                      constant: adaptationToDifferentScreenSize(withSpecificSize: Offsets.topSpecificOffset32_5,
                                                                                andDefaultSize: Offsets.topDefaultOffset65)).isActive = true
        lockIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lockIcon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.heightWidthSize0_1).isActive = true
        lockIcon.heightAnchor.constraint(equalTo: lockIcon.widthAnchor).isActive = true
        
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.topAnchor.constraint(equalTo: lockIcon.bottomAnchor,
                                       constant: adaptationToDifferentScreenSize(withSpecificSize: Offsets.topSpecificOffset32_5,
                                                                                 andDefaultSize: Offsets.topDefaultOffset65)).isActive = true
        nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.nameFieldWidthSize).isActive = true
        
        nameFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        nameFieldDivider.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: Offsets.bottomLeftOffset5).isActive = true
        nameFieldDivider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameFieldDivider.widthAnchor.constraint(equalTo: nameField.widthAnchor).isActive = true
        nameFieldDivider.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.nameFieldDividerHeightSize).isActive = true
        
        numberOfCharactersLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfCharactersLabel.topAnchor.constraint(equalTo: nameFieldDivider.bottomAnchor, constant: Offsets.bottomLeftOffset5).isActive = true
        numberOfCharactersLabel.leftAnchor.constraint(equalTo: nameFieldDivider.leftAnchor).isActive = true
        
        birthdayField.translatesAutoresizingMaskIntoConstraints = false
        birthdayField.topAnchor.constraint(equalTo: nameFieldDivider.bottomAnchor,
                                           constant: adaptationToDifferentScreenSize(withSpecificSize: Offsets.topSpecificOffset30,
                                                                                     andDefaultSize: Offsets.topDefaultOffset40)).isActive = true
        birthdayField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        birthdayField.widthAnchor.constraint(equalTo: nameField.widthAnchor).isActive = true
        
        birthdayFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        birthdayFieldDivider.topAnchor.constraint(equalTo: birthdayField.bottomAnchor, constant: Offsets.bottomLeftOffset5).isActive = true
        birthdayFieldDivider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        birthdayFieldDivider.widthAnchor.constraint(equalTo: nameFieldDivider.widthAnchor).isActive = true
        birthdayFieldDivider.heightAnchor.constraint(equalTo: nameFieldDivider.heightAnchor).isActive = true
        
        genderField.translatesAutoresizingMaskIntoConstraints = false
        genderField.topAnchor.constraint(equalTo: birthdayField.bottomAnchor,
                                         constant: adaptationToDifferentScreenSize(withSpecificSize: Offsets.topSpecificOffset30,
                                                                                   andDefaultSize: Offsets.topDefaultOffset40)).isActive = true
        genderField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        genderField.widthAnchor.constraint(equalTo: nameField.widthAnchor).isActive = true
        
        genderFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        genderFieldDivider.topAnchor.constraint(equalTo: genderField.bottomAnchor, constant: Offsets.bottomLeftOffset5).isActive = true
        genderFieldDivider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        genderFieldDivider.widthAnchor.constraint(equalTo: nameFieldDivider.widthAnchor).isActive = true
        genderFieldDivider.heightAnchor.constraint(equalTo: nameFieldDivider.heightAnchor).isActive = true
    }
    
    private func setupView() {
        title = Strings.viewSavedTitle
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
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Sizes.widthSize18, height: Sizes.heightSize18))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Sizes.viewWidthSize, height: Sizes.heightSize18))
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
        saveEditButton.setTitle(Strings.saveEditButtonEditTitle, for: .normal)
        lockIcon.image = UIImage(systemName: Images.lockImage)
        addUserpicButton.isHidden = true
        numberOfCharactersLabel.isHidden = true
        nameField.isUserInteractionEnabled = false
        birthdayField.isUserInteractionEnabled = false
        genderField.isUserInteractionEnabled = false
    }

    private func editModeIsActive() {
        saveEditButton.setTitle(Strings.saveButtonTitle, for: .normal)
        lockIcon.image = UIImage(systemName: Images.lockOpenImage)
        addUserpicButton.isHidden = false
        nameField.isUserInteractionEnabled = true
        birthdayField.isUserInteractionEnabled = true
        genderField.isUserInteractionEnabled = true
    }
    
    private func getDateFromPicker(with date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = Strings.dateFormat
        birthdayPicker.date = date
        birthdayField.text = formatter.string(from: date)
    }
    
    private func adaptationToDifferentScreenSize(withSpecificSize: CGFloat, andDefaultSize: CGFloat) -> CGFloat {
        let device = UIDevice()
        if device.name == Strings.iPodTouchName ||
            device.name == Strings.iPhoneSEName ||
            device.name == Strings.iPhone8Name ||
            device.name == Strings.iPhone8PlusName {
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
        
        guard let text = nameField.text, !text.isEmpty else {
            presenter.presentEnterNameAlert()
            isEditButton = true
            return
        }
        
        let newText = ProfileListViewController.removeSpacesFrom(text)
        
        if newText.count < Limitation.textCount3 || newText.count > Limitation.textCount16 {
            presenter.presentInvalidNumberAlert()
            isEditButton = true
            return
        } else {
            editModeInactive()
            presenter.saveNewProfileData(with: selectedProfile,
                                         newName: newText.trimmingCharacters(in: .whitespaces),
                                         newBirthday: (birthdayField.text?.isEmpty ?? true) ? nil : birthdayPicker.date,
                                         newGender: genderField.text ?? "",
                                         newUserpic: profileImage.image?.pngData() ?? Data())
        }
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
        if row == 0 {
            genderField.text = ""
        } else {
            genderField.text = genders[row]
        }
    }
}
