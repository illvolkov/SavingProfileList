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
}
