//
//  ProfileListPresenter.swift
//  SavingProfileList
//
//  Created by Ilya Volkov on 11.07.2022.
//

import Foundation
import UIKit

protocol ProfileListPresenterDelegate {
    func present(profiles: [Profile])
}

final class ProfileListPresenter {
    
    typealias PresenterDelegate = ProfileListPresenterDelegate & UIViewController
    
    //MARK: - References
    
    weak public var delegate: PresenterDelegate?
    public var storageService: StorageServiceProtocol?
    
    //MARK: - Functions
    
    public func getProfiles() {
        
        guard let storageService = storageService else { return }

        storageService.giveProfiles {
            
            guard let delegate = delegate else { return }

            delegate.present(profiles: storageService.models)
        }
    }
    
    public func presentEnterNameAlert() {
        
        let alert = UIAlertController(title: "Enter profile name", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        guard let delegate = delegate else { return }
        
        delegate.present(alert, animated: true)
    }
    
    public func presentInvalidNumberAlert() {
        
        let alert = UIAlertController(title: "Invalid number of characters",
                                      message: "Enter a name containing from 3 to 15 characters",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        guard let delegate = delegate else { return }
        
        delegate.present(alert, animated: true)
    }
    
    public func saveProfileBy(name: String) {
        
        guard let storageService = storageService else { return }
        
        storageService.createProfileBy(name: name)
    }
    
    public func delete(profile: Profile) {
        
        guard let storageService = storageService else { return }
        
        storageService.delete(profile: profile)
    }
    
    public func showDetailProfileViewController(with selectedProfile: Profile) {
        let detailProfileViewController = ModuleBuilder.createDetailProfileModule(with: selectedProfile)
        guard let delegate = delegate else { return }
        
        detailProfileViewController.modalPresentationStyle = .fullScreen
        delegate.present(detailProfileViewController, animated: true)
    }
}
