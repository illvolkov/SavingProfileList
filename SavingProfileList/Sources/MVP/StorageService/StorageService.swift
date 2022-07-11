//
//  StorageService.swift
//  SavingProfileList
//
//  Created by Ilya Volkov on 11.07.2022.
//

import Foundation
import UIKit

private protocol StorageServiceProtocol {
    func giveProfiles(completion: () -> Void)
    func createProfileBy(name: String)
    func delete(profile: Profile)
    func updateProfile(_ profile: Profile, newName: String, newBirthday: Date, newGender: String, newUserpic: Data)
}

final class StorageService: StorageServiceProtocol {

    public var models = [Profile]()
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            
    public func giveProfiles(completion: () -> Void) {
        guard let context = context else { return }
        
        do {
            models = try context.fetch(Profile.fetchRequest())
            completion()
            print("Profiles given to the Presenter")
        }
        catch {
            print(error)
        }
    }
    
    public func createProfileBy(name: String) {
        guard let context = context else { return }
        
        let newProfile = Profile(context: context)
        newProfile.name = name
        
        do {
            try context.save()
            giveProfiles {
                print("Profile created")
            }
        }
        catch {
            print(error)
        }
    }
    
    public func delete(profile: Profile) {
        guard let context = context else { return }
        
        context.delete(profile)

        do {
            try context.save()
            giveProfiles {
                print("Profile deleted")
            }
        }
        catch {
            print(error)
        }
    }
    
    public func updateProfile(_ profile: Profile, newName: String, newBirthday: Date, newGender: String, newUserpic: Data) {
        guard let context = context else { return }
    
        profile.name = newName
        profile.birthday = newBirthday
        profile.gender = newGender
        profile.userpic = newUserpic
        
        do {
            try context.save()
            giveProfiles {
                print("Profile updated")
            }
        }
        catch {
            print(error)
        }
    }
}
