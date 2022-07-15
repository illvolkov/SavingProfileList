//
//  DetailProfilePresenter.swift
//  SavingProfileList
//
//  Created by Ilya Volkov on 12.07.2022.
//

import Foundation
import UIKit
import PhotosUI

protocol DetailProfilePresenterDelegate {
    func saveProfileData()
    var isEditButton: Bool { get set }
}

final class DetailProfilePresenter {
    typealias DetailPresenterDelegate = DetailProfilePresenterDelegate & UIViewController

    weak public var delegate: DetailPresenterDelegate?
    public var storageSerivce: StorageServiceProtocol?
    
    public func dismissDetailProfileViewController() {
        guard let delegate = delegate else { return }
        
        if delegate.isEditButton {
            let alert = UIAlertController(title: "Save changes?", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                delegate.saveProfileData()
                delegate.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
                delegate.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            delegate.present(alert, animated: true)
        } else {
            delegate.dismiss(animated: true)
        }
    }
    
    public func saveNewProfileData(with profile: Profile, newName: String, newBirthday: Date?, newGender: String, newUserpic: Data) {
        guard let storageSerivce = storageSerivce else { return }

        storageSerivce.updateProfile(profile, newName: newName, newBirthday: newBirthday, newGender: newGender, newUserpic: newUserpic)
    }
    
    public func addOrDeleteUserpicWithSheet(together phpickerDelegate: PHPickerViewControllerDelegate, imageView: UIImageView) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        guard let delegate = self.delegate else { return }
        
        sheet.addAction(UIAlertAction(title: "Choose a picture", style: .default, handler: { _ in
                        
            var config = PHPickerConfiguration()
            config.selectionLimit = 1
            config.filter = PHPickerFilter.images
            
            let pickerViewController = PHPickerViewController(configuration: config)
            pickerViewController.delegate = phpickerDelegate
                        
            delegate.present(pickerViewController, animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete a picture", style: .destructive, handler: { _ in
            
            if imageView.image == UIImage(named: "empty.avatar") {
                return
            } else {
                imageView.image = UIImage(named: "empty.avatar")
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        delegate.present(sheet, animated: true)
    }
    
    public func presentInvalidNumberAlert() {
        
        let alert = UIAlertController(title: "Invalid number of characters",
                                      message: "Enter a name containing from 3 to 15 characters",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        guard let delegate = delegate else { return }
        
        delegate.present(alert, animated: true)
    }
}
