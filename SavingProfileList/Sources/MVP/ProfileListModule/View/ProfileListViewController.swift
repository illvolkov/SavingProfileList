//
//  ViewController.swift
//  SavingProfileList
//
//  Created by Ilya Volkov on 10.07.2022.
//

import UIKit

protocol ProfileListViewProtocol: AnyObject {
    func present(profiles: [Profile])
}

final class ProfileListViewController: UIViewController {
    
    //MARK: - References
    
    public var presenter: ProfileListPresenter?
    
    //MARK: - Variables
    
    private var models = [Profile]()
    
    //MARK: - Views
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: Images.backgroundImage)
        
        return imageView
    }()
    
    private lazy var hStackView: UIStackView = {
        let hStack = UIStackView()
        
        hStack.axis = .horizontal
        hStack.spacing = view.frame.width * Offsets.hStackSpacing
        
        return hStack
    }()
    
    private lazy var nameField: UITextField = {
        let nameField = UITextField()
        
        if let button = nameField.value(forKey: Strings.clearButtonKey) as? UIButton {
            button.tintColor = .white
            button.setImage(UIImage(systemName: Images.clearButtonImage), for: .normal)
        }
        
        nameField.placeholder = Strings.nameFieldPlaceholder
        nameField.borderStyle = .roundedRect
        nameField.textColor = .white
        nameField.layer.borderColor = UIColor.white.cgColor
        nameField.layer.borderWidth = Sizes.borderWidth2
        nameField.layer.cornerRadius = view.frame.width * Sizes.cornerRadius2
        nameField.clearButtonMode = .whileEditing
        
        return nameField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Strings.cancelTitle, for: .normal)
        if let titleLabel = button.titleLabel {
            titleLabel.textColor = .white
            titleLabel.font = .systemFont(ofSize: view.frame.width * Sizes.fontSize0_045)
        }
        button.addTarget(self, action: #selector(hideInputElements), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Strings.saveButtonTitle, for: .normal)
        if let titleLabel = button.titleLabel {
            titleLabel.textColor = .white
            titleLabel.font = .systemFont(ofSize: view.frame.width * Sizes.fontSize0_045)
        }
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = Sizes.borderWidth2
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .clear
        tableView.separatorColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Strings.cellIdentifier)
        
        return tableView
    }()
    
    private lazy var numberOfCharactersLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.numberOfCharactersLabelText
        label.textColor = .white
        label.font = .systemFont(ofSize: view.frame.width * Sizes.numberOfCharactersLabelFontSize)
        return label
    }()
    
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .white
        return separator
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
        setupLayout()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presenter = presenter {
            presenter.getProfiles()
        }
        setupNavigationBar()
        showHideCancelButton()
    }
    
    //MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(backgroundImage)
        view.addSubview(hStackView)
        hStackView.addArrangedSubview(nameField)
        hStackView.addArrangedSubview(cancelButton)
        view.addSubview(numberOfCharactersLabel)
        view.addSubview(saveButton)
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Offsets.hStackViewTopOffset).isActive = true
        hStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Offsets.bottomLeftOffset30).isActive = true
        hStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Offsets.bottomLeftOffset30).isActive = true
        
        numberOfCharactersLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfCharactersLabel.topAnchor.constraint(equalTo: hStackView.bottomAnchor, constant: Offsets.bottomLeftOffset5).isActive = true
        numberOfCharactersLabel.leftAnchor.constraint(equalTo: hStackView.leftAnchor, constant: Offsets.bottomLeftOffset5).isActive = true
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: hStackView.bottomAnchor, constant: Offsets.bottomLeftOffset30).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.widthSize0_2).isActive = true
        saveButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.heightWidthSize0_1).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: Offsets.bottomLeftOffset30).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupView() {
        title = Strings.viewSaveTitle
    }
    
    private func setupNavigationBar() {
        
        guard let navigationController = navigationController else { return }
        
        navigationController.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.standardAppearance = appearance
    }
    
    //MARK: - Functions
    
    private func showHideCancelButton() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        cancelButton.isHidden = true
        numberOfCharactersLabel.isHidden = true
    }
    
    static public func removeSpacesFrom(_ text: String) -> String {
        var newText = ""
        for char in text {
            if char != " " {
                newText.append(char)
            }
        }
        return newText
    }
    
    //MARK: - Actions
    
    @objc private func hideInputElements() {
        nameField.resignFirstResponder()
        UIView.animate(withDuration: Display.animateDuration0_4) {
            self.cancelButton.isHidden = true
            self.numberOfCharactersLabel.isHidden = true
        }
    }
    
    @objc private func saveButtonDidTap() {
        
        guard let presenter = presenter else { return }
        
        guard let text = nameField.text, !text.isEmpty else {
            presenter.presentEnterNameAlert()
            return
        }
        
        let newText = ProfileListViewController.removeSpacesFrom(text)
        
        if newText.count < Limitation.textCount3 || newText.count > Limitation.textCount16 {
            presenter.presentInvalidNumberAlert()
        } else {
            presenter.saveProfileBy(name: newText.trimmingCharacters(in: .whitespaces))
            presenter.getProfiles()
            hideInputElements()
            nameField.text = ""
        }
    }
    
    @objc private func keyBoardWillShow(notification: NSNotification) {
        UIView.transition(with: cancelButton, duration: Display.animateDuration0_4, options: .transitionFlipFromRight) {
            self.cancelButton.isHidden = false
            self.numberOfCharactersLabel.isHidden = false
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource methods

extension ProfileListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.cellIdentifier, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = models[indexPath.row].name
        cell.contentConfiguration = content
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = models[indexPath.row]
        guard let presenter = presenter else { return }
        presenter.showDetailProfileViewController(with: model)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.width * Sizes.heightForRow
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let profile = models.remove(at: indexPath.row)
            
            if let presenter = presenter {
                presenter.delete(profile: profile)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            tableView.endUpdates()
        }
    }
}

//MARK: - ProfileListPresenterDelegate methods

extension ProfileListViewController: ProfileListPresenterDelegate {
    func present(profiles: [Profile]) {
        self.models = profiles
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
