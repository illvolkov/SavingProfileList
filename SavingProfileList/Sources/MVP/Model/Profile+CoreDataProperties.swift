//
//  Profile+CoreDataProperties.swift
//  SavingProfileList
//
//  Created by Ilya Volkov on 11.07.2022.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: Strings.entityName)
    }

    @NSManaged public var name: String?
    @NSManaged public var birthday: Date?
    @NSManaged public var gender: String?
    @NSManaged public var userpic: Data?

}

extension Profile : Identifiable {

}
