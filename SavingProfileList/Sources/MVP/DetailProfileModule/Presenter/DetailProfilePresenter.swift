//
//  DetailProfilePresenter.swift
//  SavingProfileList
//
//  Created by Ilya Volkov on 12.07.2022.
//

import Foundation
import UIKit

protocol DetailProfilePresenterDelegate {
    
}

final class DetailProfilePresenter {
    typealias DetailPresenterDelegate = DetailProfilePresenterDelegate & UIViewController

    weak public var delegate: DetailPresenterDelegate?
    public var storageSerivce: StorageServiceProtocol?
}
