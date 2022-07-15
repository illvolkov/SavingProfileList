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
    
    //MARK: - References

    weak public var delegate: DetailPresenterDelegate?
    public var storageSerivce: StorageServiceProtocol?
    
    //MARK: - Functions
    
    public func dismissDetailProfileViewController() {
        guard let delegate = delegate else { return }
        
        if delegate.isEditButton {
            let alert = UIAlertController(title: Strings.saveChangesAlertTitle, message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: Strings.saveChangesAlertActionTitleYes, style: .default, handler: { _ in
                delegate.saveProfileData()
                delegate.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: Strings.saveChangesAlertActionTitleNo, style: .default, handler: { _ in
                delegate.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: Strings.cancelTitle, style: .cancel))
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
        
        sheet.addAction(UIAlertAction(title: Strings.chooseAPictureSheetTitle, style: .default, handler: { _ in
                        
            var config = PHPickerConfiguration()
            config.selectionLimit = Limitation.selectionLimit
            config.filter = PHPickerFilter.images
            
            let pickerViewController = PHPickerViewController(configuration: config)
            pickerViewController.delegate = phpickerDelegate
                        
            delegate.present(pickerViewController, animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: Strings.chooseAPictureSheetActionTitle, style: .destructive, handler: { _ in
            
            if imageView.image == UIImage(named: Images.emptyAvatarImage) {
                return
            } else {
                imageView.image = UIImage(named: Images.emptyAvatarImage)
            }
        }))
        
        sheet.addAction(UIAlertAction(title: Strings.cancelTitle, style: .cancel))
        
        delegate.present(sheet, animated: true)
    }
    
    public func presentInvalidNumberAlert() {
        
        let alert = UIAlertController(title: Strings.invalidNumberAlertTitle,
                                      message: Strings.invalidNumberAlertMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.alertActionTitleOk, style: .cancel))
        
        guard let delegate = delegate else { return }
        
        delegate.present(alert, animated: true)
    }
}
