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
                let model = data.data?.decodeModel(type: ProfileData.self)
                completion(model, nil)
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
