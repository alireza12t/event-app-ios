//
//  ProfileTabBar.swift
//  EventApp
//
//  Created by ali on 4/16/21.
//  Copyright © 2021 Alexani. All rights reserved.
//

import SwiftUI
import NavigationStack

class UserSettings: ObservableObject {
    @Published var loginSetting = LoginSetting()
}

struct LoginSetting {
    var phoneNumber: String = ""
    var loginToken: String = ""
    var token: String = DataManager.shared.token
}

struct ProfileTabBar: View {
    
    @ObservedObject var viewModel = ProfileViewModel(shouldSetup: false)
    @ObservedObject var userSettings = UserSettings()
    @State private var selectedTab: Int = 1
    
    init() {
        if !userSettings.loginSetting.token.isEmpty && viewModel.repositories == nil {
            viewModel.setup()
        }
    }
    
    var body: some View {
        ZStack {
            if userSettings.loginSetting.token.isEmpty {
                if userSettings.loginSetting.loginToken.isEmpty {
                    PhoneNumberView(loginSetting: $userSettings.loginSetting)
                } else {
                    OTPView(loginSetting: $userSettings.loginSetting)
                }
            } else {
                if self.viewModel.statusView == .loading {
                    Indicator()
                } else {
                    if !viewModel.doesNeedProfileUpdate {
                        NavigationStackView(transitionType: .custom(.scale)) {
                            GeometryReader { geo in
                                VStack(spacing: 20){
                                    ScrollableTabView(activeIdx: $selectedTab, dataSet: ["Chats", "YourProfile"])
                                        .frame(width: geo.size.width, height: 40)
                                    if selectedTab == 0 {
                                        ChatHistoryView()
                                            .frame(width: geo.size.width, height: geo.size.height - 90)
                                    } else {
                                        ProfileView(viewModel: viewModel, isMyProfile: true, userId: "!")
                                            .frame(maxWidth: .infinity)
                                            .frame(height: geo.size.height - 90)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    } else {
                        NavigationStackView(transitionType: .custom(.scale)) {
                            EditProfileView(viewModel: viewModel)
                        }
                    }
                }
            }
        }
    }
}

struct ProfileTabBar_Previews: PreviewProvider {
    
    static var previews: some View {
        ProfileTabBar()
    }
}
