//
//  ProfileListPresenter.swift
//  SavingProfileList
//
//  Created by Ilya Volkov on 11.07.2022.
//

import Foundation
import UIKit

protocol ProfileListPresenterDelegate: AnyObject {
    func present(profiles: [Profile])
}

typealias PresenterDelegate = ProfileListPresenterDelegate & UIViewController

final class ProfileListPresenter {
    
    weak private var delegate: PresenterDelegate?
    private var storageService: StorageServiceProtocol?
    
    public func getProfiles() {
        guard let storageService = storageService else { return }

        storageService.giveProfiles {
            guard let delegate = delegate else { return }

            delegate.present(profiles: storageService.models)
        }
    }
    
    public func setView(delegate: PresenterDelegate) {
        self.delegate = delegate
    }
}
