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
    var isProfileFilled: Bool = false
}

struct ProfileTabBar: View {
    
    @ObservedObject var userSettings = UserSettings()
    @State private var selectedTab: Int = 1

    var body: some View {
//        if userSettings.loginSetting.token.isEmpty {
//            if userSettings.loginSetting.loginToken.isEmpty {
//                PhoneNumberView(loginSetting: $userSettings.loginSetting)
//            } else {
//                OTPView(loginSetting: $userSettings.loginSetting)
//            }
//        } else {
//            if userSettings.loginSetting.isProfileFilled {
            NavigationStackView(transitionType: .custom(.scale)) {
                tabBarView
            }
//            } else {
//                EditProfileView()
//            }
//            MatchingView()
//            LoadingView()
//        }
    }
}

extension ProfileTabBar {
    private var tabBarView: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 20){
//                NavigationView {
                ScrollableTabView(activeIdx: $selectedTab, dataSet: ["Chats", "YourProfile"])
                    .frame(width: geo.size.width, height: 40)
                if selectedTab == 0 {
                    ChatHistoryView()
                        .frame(width: geo.size.width, height: geo.size.height - 90)
                } else {
                    ProfileView(isMyProfile: true, userId: "!")
                        .frame(width: geo.size.width, height: geo.size.height - 90)
                }
                Spacer()
                //        }
//                }
            }
            .padding()
        }
    }
}

struct ProfileTabBar_Previews: PreviewProvider {
    
    static var previews: some View {
        ProfileTabBar()
    }
}
