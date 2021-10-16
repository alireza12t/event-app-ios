//
//  MatchingViewModel.swift
//  EventApp
//
//  Created by Alireza on 10/15/21.
//  Copyright © 2021 Alexani. All rights reserved.
//

import Foundation

class MatchingViewModel: ObservableObject {
    
    var repo = MatchingRepository()
    @Published var repositories = [ProfileData.example]
    
    @Published var errorMessage: String = ""
    @Published var statusView: StatusView = .none

    init() {
        setup()
    }
    
    func setup() {
        self.statusView = .complete
//        repo.get() { repositories, exception  in
//
//            if let error = exception {
//                self.statusView = .error
//                self.errorMessage = error.message
//                return
//            }
//
//            guard let repositories = repositories else {
//                return
//            }
//            self.statusView = .complete
//            self.repositories = repositories
////            self.repositories = ProfileData.example
//        }
    }
}
