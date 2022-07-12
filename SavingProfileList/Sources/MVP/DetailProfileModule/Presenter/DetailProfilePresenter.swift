//
//  ProfilePresenter.swift
//  SavingProfileList
//
//  Created by Ilya Volkov on 12.07.2022.
//

import Foundation
import UIKit

protocol ProfilePresenterDelegate {
    
}

typealias DetailPresenterDelegate = ProfilePresenterDelegate & UIViewController

final class DetailProfilePresenter {
    
    weak public var delegate: DetailPresenterDelegate?
    public var storageService: StorageServiceProtocol?
}
