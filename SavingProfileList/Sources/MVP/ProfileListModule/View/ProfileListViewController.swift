//
//  ViewController.swift
//  SavingProfileList
//
//  Created by Ilya Volkov on 10.07.2022.
//

import UIKit

class ProfileListViewController: UIViewController {
    
    //MARK: - References
    
    private var presenter = ProfileListPresenter()
    
    //MARK: - Variables
    
    private var models = [Profile]()
    
    //MARK: - Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setView(delegate: self)
    }
}

//MARK: - ProfileListPresenterDelegate methods

extension ProfileListViewController: ProfileListPresenterDelegate {
    func present(profiles: [Profile]) {
        self.models = profiles
        
        tableView.reloadData()
    }
}
