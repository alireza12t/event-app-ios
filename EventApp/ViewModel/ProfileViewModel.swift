//
//  ProfileViewModel.swift
//  EventApp
//
//  Created by ali on 4/24/21.
//  Copyright © 2021 Alexani. All rights reserved.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    var repo = ProfilleRepository()
    @Published var repositories: ProfileData!
    @Published var allInterests = [InterestType]()

    @Published var errorMessage: String = ""
    @Published var statusView: StatusView = .none
    
    @Published var emailText: String = ""
    @Published var firstNameText: String = ""
    @Published var LastNameText: String = ""
    @Published var educationFieldText: String = ""
    @Published var jobTitleText: String = ""
    @Published var biographyText: String = ""

    @Published var doesNeedProfileUpdate: Bool = false

    var firstName: String {
        return repositories.firstName ?? ""
    }
    
    var lastName: String {
        return repositories.firstName ?? ""
    }
    
    var biography: String {
        return repositories.biography ?? ""
    }
    
    var email: String {
        return repositories.email ?? ""
    }

    var phoneNumber: String {
        return repositories.phone ?? ""
    }
    
    var jobTitle: String {
        return repositories.jobTitle ?? ""
    }
    
    var educationField: String {
        return repositories.educationField ?? ""
    }
    
    var interestList: [InterestType] {
        return repositories.interests ?? []
    }
    
    var tags: [TagViewItem] {
        allInterests.compactMap({
            if interestList.contains($0) {
                return TagViewItem(title: $0.name, isSelected: true)
            } else {
                return TagViewItem(title: $0.name, isSelected: false)
            }
        })
    }
    
    init() {
        setup()
    }
    
    func setup() {
        self.statusView = .loading
        repo.get() { repositories, exception  in
            
            if let error = exception {
                self.statusView = .error
                self.errorMessage = error.message
                return
            }
            
            guard let repositories = repositories else {
                self.statusView = .error
                return
            }
            self.repositories = repositories
            self.doesNeedProfileUpdate = repositories.doesNeedProfileUpdate ?? true
            self.emailText = repositories.email ?? ""
            self.firstNameText = repositories.firstName ?? ""
            self.LastNameText = repositories.lastName ?? ""
            self.educationFieldText = repositories.educationField ?? ""
            self.jobTitleText = repositories.jobTitle ?? ""
            self.biographyText = repositories.biography ?? ""
            self.getInterests()
        }
    }
    
    func getInterests() {
        repo.getInterestList() { repositories, exception  in
            
            if let error = exception {
                self.statusView = .error
                self.errorMessage = error.message
                return
            }
            
            guard let repositories = repositories else {
                self.statusView = .error
                return
            }
            self.statusView = .complete
            self.allInterests = repositories.interests ?? []
        }
    }
    
    func updateProfile(completion: @escaping (Bool) -> Void) {
        self.statusView = .loading
        repo.update(newPrrofile: ProfileMutationInput(email: emailText, firstName: firstNameText, lastName: LastNameText, jobTitle: jobTitleText, educationField: educationFieldText, biography: biographyText, interests: [], linkedinId: "", id: repositories.id, clientMutationId: "")) { repositories, exception  in
            
            if let error = exception {
                self.statusView = .error
                self.errorMessage = error.message
                completion(false)
                return
            }
            
            guard let repositories = repositories else {
                completion(false)
                return
            }
            self.statusView = .complete
            self.repositories = repositories
            completion(true)
        }
    }
}
