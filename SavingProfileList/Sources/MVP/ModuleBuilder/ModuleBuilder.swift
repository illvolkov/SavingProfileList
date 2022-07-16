//
//  ModuleBuilder.swift
//  SavingProfileList
//
//  Created by Ilya Volkov on 12.07.2022.
//

import Foundation
import UIKit

final class ModuleBuilder {
    static func createProfileListModule() -> UIViewController {
        let view = ProfileListViewController()
        let storageService = StorageService()
        let presenter = ProfileListPresenter()
        
        view.presenter = presenter
        presenter.delegate = view
        presenter.storageService = storageService
        return view
    }
    
    static func createDetailProfileModule(with selectedProfile: Profile) -> UIViewController {
        let view = DetailProfileViewController(selectedProfile: selectedProfile)
        let presenter = DetailProfilePresenter()
        let storageService = StorageService()
        
        view.presenter = presenter
        presenter.delegate = view
        presenter.storageSerivce = storageService
        return view
    }
}
