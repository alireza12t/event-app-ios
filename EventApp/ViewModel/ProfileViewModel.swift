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
        return repositories?.firstName ?? ""
    }
    
    var lastName: String {
        return repositories?.lastName ?? ""
    }
    
    var biography: String {
        return repositories?.biography ?? ""
    }
    
    var email: String {
        return repositories?.email ?? ""
    }
    
    var phoneNumber: String {
        return repositories?.phone ?? ""
    }
    
    var jobTitle: String {
        return repositories?.jobTitle ?? ""
    }
    
    var educationField: String {
        return repositories?.educationField ?? ""
    }
    
    var interestList: [InterestType] {
        return repositories?.interests ?? []
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
    
    init(shouldSetup: Bool = true) {
        if shouldSetup && profile?.id == nil && profile == nil {
            setup()
            getInterests()
        } else {
            repositories = profile
            fillProfileTexts()
            statusView = .complete
        }
    }
    
    func setup() {
        self.statusView = .loading
        repo.get() { repositories, exception  in
            
            if let error = exception {
                self.errorMessage = error.message
                self.statusView = .error
                return
            }
            
            guard let repositories = repositories else {
                self.statusView = .error
                return
            }
            profile = repositories
            self.repositories = repositories
            self.doesNeedProfileUpdate = repositories.doesNeedProfileUpdate ?? true
            self.fillProfileTexts()
            self.statusView = .complete
        }
    }
    
    func fillProfileTexts() {
        emailText = repositories?.email ?? ""
        firstNameText = repositories?.firstName ?? ""
        LastNameText = repositories?.lastName ?? ""
        educationFieldText = repositories?.educationField ?? ""
        jobTitleText = repositories?.jobTitle ?? ""
        biographyText = repositories?.biography ?? ""
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
            self.allInterests = repositories.interests ?? []
            self.statusView = .complete
        }
    }
    
    func updateProfile(completion: @escaping (Bool) -> Void) {
        self.statusView = .loading
        repo.update(newPrrofile: ProfileMutationInput(email: emailText, firstName: firstNameText, lastName: LastNameText, jobTitle: jobTitleText, educationField: educationFieldText, biography: biographyText, interests: [], linkedinId: "", id: repositories.id, clientMutationId: "")) { repositories, exception  in
            
            if let error = exception {
                self.errorMessage = error.message
                self.statusView = .error
                completion(false)
                return
            }
            
            guard let repositories = repositories else {
                self.statusView = .error
                completion(false)
                return
            }
            self.repositories = repositories
            self.statusView = .complete
            self.fillProfileTexts()
            completion(true)
        }
    }
}
