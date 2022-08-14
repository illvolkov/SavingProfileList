//
//  Constants.swift
//  SavingProfileList
//
//  Created by Ilya Volkov on 15.07.2022.
//

import UIKit

enum Offsets {
    static let hStackSpacing: CGFloat = 0.05
    static let hStackViewTopOffset: CGFloat = 50
    static let bottomLeftOffset30: CGFloat = 30
    static let bottomLeftOffset5: CGFloat = 5
    static let profileImageXYBoundsOffset0_06: CGFloat = 0.06
    static let profileImageWidthHeightOffset0_88: CGFloat = 0.88
    static let topBottomOffset80: CGFloat = 80
    static let topBarHStackLeftOffset: CGFloat = 15
    static let topBarHStackRightOffset: CGFloat = -20
    static let topBarHStackBottomSpecificOffset: CGFloat = 40
    static let topSpecificOffset32_5: CGFloat = 32.5
    static let topDefaultOffset65: CGFloat = 65
    static let topSpecificOffset30: CGFloat = 30
    static let topDefaultOffset40: CGFloat = 40
}

enum Sizes {
    static let borderWidth2: CGFloat = 2
    static let cornerRadius2: CGFloat = 0.02
    static let profileImageCornerRadius: CGFloat = 0.2
    static let fontSize0_045: CGFloat = 0.045
    static let numberOfCharactersLabelFontSize: CGFloat = 0.03
    static let widthSize0_2: CGFloat = 0.2
    static let heightWidthSize0_1: CGFloat = 0.1
    static let heightForRow: CGFloat = 0.2
    static let dismissButtomImageSize: CGFloat = 0.08
    static let addUserpicButtonImageSize: CGFloat = 0.35
    static let widthSize18: CGFloat = 18
    static let heightSize18: CGFloat = 18
    static let viewWidthSize: CGFloat = 25
    static let profileImageWidthSize: CGFloat = 0.4
    static let nameFieldWidthSize: CGFloat = 0.5
    static let nameFieldDividerHeightSize: CGFloat = 0.001
}

enum Strings {
    static let enterNameAlertTitle: String = "Enter profile name"
    static let alertActionTitleOk: String = "Ok"
    static let invalidNumberAlertTitle: String = "Invalid number of characters"
    static let invalidNumberAlertMessage: String = "Enter a name containing from 3 to 15 characters"
    static let clearButtonKey: String = "clearButton"
    static let nameFieldPlaceholder: String = "Enter profile name"
    static let cancelTitle: String = "Cancel"
    static let saveButtonTitle: String = "Save"
    static let cellIdentifier: String = "cell"
    static let numberOfCharactersLabelText: String = "from 3 to 16 characters"
    static let viewSaveTitle: String = "Save profile"
    static let saveChangesAlertTitle: String = "Save changes?"
    static let saveChangesAlertActionTitleYes: String = "Yes"
    static let saveChangesAlertActionTitleNo: String = "No"
    static let chooseAPictureSheetTitle: String = "Choose a picture"
    static let chooseAPictureSheetActionTitle: String = "Delete a picture"
    static let nameFieldPlaceholderName: String = "Name"
    static let birthdayFieldPlaceholder: String = "Birthday"
    static let genderFieldPlaceholder: String = "Gender"
    static let viewSavedTitle: String = "Saved profile"
    static let saveEditButtonEditTitle: String = "Edit"
    static let dateFormat: String = "dd.MM.yyyy"
    static let iPodTouchName: String = "iPod touch (7th generation)"
    static let iPhoneSEName: String = "iPhone SE (3rd generation)"
    static let iPhone8Name: String = "iPhone 8"
    static let iPhone8PlusName: String = "iPhone 8 Plus"
    static let entityName: String = "Profile"
    static let giveProfilesCompletion: String = "Profiles given to the Presenter"
    static let profileCreatedCompletion: String = "Profile created"
    static let profileDeletedCompletion: String = "Profile deleted"
    static let profileUpdatedCompletion: String = "Profile updated"
}

enum Sequences {
    static let gendersList: [String] = ["Choose a gender",
                                        "Male",
                                        "Female",
                                        "Lesbian",
                                        "Gay",
                                        "Bisexual",
                                        "Transgender",
                                        "Agender",
                                        "Androgyne",
                                        "Bigender",
                                        "Cis male",
                                        "Cis female",
                                        "FTM",
                                        "MTF",
                                        "Gender Fluid",
                                        "Gender Nonconforming",
                                        "Gender Questioning",
                                        "Gender Variant",
                                        "Genderqueer",
                                        "Neutrois",
                                        "Non-binary",
                                        "Other",
                                        "Pangender",
                                        "Two-spirit",
                                        "Anongender",
                                        "Cavusgender",
                                        "Zodiacgender",
                                        "Aesthetgender",
                                        "Affectugender",
                                        "Digigender",
                                        "Egogender"]
}

enum Images {
    static let backgroundImage: String = "gradient.back"
    static let clearButtonImage: String = "xmark.circle.fill"
    static let emptyAvatarImage: String = "empty.avatar"
    static let dismissButtonImage: String = "xmark.app"
    static let addUserpicButtonImage: String = "plus.circle.fill"
    static let nameFieldImages: String = "person.fill"
    static let birthdayFieldImage: String = "calendar"
    static let genderFieldImage: String = "allergens"
    static let lockImage: String = "lock.fill"
    static let lockOpenImage: String = "lock.open.fill"
}

enum Display {
    static let animateDuration0_4: CGFloat = 0.4
    static let addUserpicButtonAlpha: CGFloat = 0.5
}

enum Limitation {
    static let textCount3: Int = 3
    static let textCount16: Int = 16
    static let selectionLimit: Int = 1
}
