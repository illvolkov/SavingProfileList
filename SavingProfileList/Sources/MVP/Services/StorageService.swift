//
//  StorageService.swift
//  SavingProfileList
//
//  Created by Ilya Volkov on 11.07.2022.
//

import Foundation
import UIKit

protocol StorageServiceProtocol {
    func giveProfiles(completion: () -> Void)
    func createProfileBy(name: String)
    func delete(profile: Profile)
    func updateProfile(_ profile: Profile, newName: String, newBirthday: Date?, newGender: String, newUserpic: Data)
    var models: [Profile] { get set }
}

final class StorageService: StorageServiceProtocol {
    
    //MARK: - Variables

    public var models = [Profile]()
    
    //MARK: - CoreData
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            
    public func giveProfiles(completion: () -> Void) {
        guard let context = context else { return }
        
        do {
            models = try context.fetch(Profile.fetchRequest())
            completion()
            print(Strings.giveProfilesCompletion)
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
                print(Strings.profileCreatedCompletion)
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
                print(Strings.profileDeletedCompletion)
            }
        }
        catch {
            print(error)
        }
    }
    
    public func updateProfile(_ profile: Profile, newName: String, newBirthday: Date?, newGender: String, newUserpic: Data) {
        guard let context = context else { return }
    
        profile.name = newName
        profile.birthday = newBirthday
        profile.gender = newGender
        profile.userpic = newUserpic
        
        do {
            try context.save()
            giveProfiles {
                print(Strings.profileUpdatedCompletion)
            }
        }
        catch {
            print(error)
        }
    }
}
