//
//  ProfileRepository.swift
//  EventApp
//
//  Created by ali on 4/24/21.
//  Copyright © 2021 Alexani. All rights reserved.
//

import Foundation

class ProfilleRepository {
    func getInterestList(completion: @escaping (AllInterests?, XException?) -> ()) {
        Network.shared.fetch(query: GetInterestListQuery()) { result in
            switch result {
            case .failure(let error):
                completion(nil, XException(message: error.localizedDescription, code: 0))
            case .success(let data):
                let model = data.data?.decodeModel(type: AllInterests.self)
                completion(model, nil)
            }
        }
    }
    
    func get(completion: @escaping (ProfileData?, XException?) -> ()) {
        Network.shared.fetch(query: GetUserProfileQuery()) { result in
            switch result {
            case .failure(let error):
                completion(nil, XException(message: error.localizedDescription, code: 0))
            case .success(let data):
                if let me = data.data?.me {
                    let model = ProfileData(dateJoined: me.dateJoined, isStaff: me.isStaff, firstName: me.firstName, lastName: me.lastName, email: me.email, phone: me.phone, jobTitle: me.jobTitle, educationField: me.educationField, biography: me.biography, id: me.id, interests: me.interests.compactMap({InterestType(id: $0.id, name: $0.name)}), pk: me.pk, doesNeedProfileUpdate: me.doesNeedProfileUpdate)
                    completion(model, nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    func update(newPrrofile: ProfileMutationInput, completion: @escaping (ProfileData?, XException?) -> ()) {
        Network.shared.perform(mutation: UpdateProfileMutation(input: newPrrofile)) { result in
            switch result {
            case .failure(let error):
                completion(nil, XException(message: error.localizedDescription, code: 0))
            case .success(_ ):
                self.get(completion: completion)
            }
        }
    }
}
