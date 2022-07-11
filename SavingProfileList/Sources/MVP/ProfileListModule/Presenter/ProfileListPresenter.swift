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

typealias PresenterDelegate = ProfileListPresenterDelegate & UIViewController

final class ProfileListPresenter {
    
    weak public var delegate: PresenterDelegate?
    public var storageService: StorageServiceProtocol?
    
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
    
    public func saveProfileBy(name: String) {
        
        guard let storageService = storageService else { return }
        
        storageService.createProfileBy(name: name)
    }
}
