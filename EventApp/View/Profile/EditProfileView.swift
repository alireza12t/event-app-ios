//
//  EditProfileView.swift
//  EventApp
//
//  Created by Alireza on 8/19/21.
//  Copyright © 2021 Alexani. All rights reserved.
//

import SwiftUI
import NavigationStack

struct EditProfileView: View {
    
    @ObservedObject var viewModel = ProfileViewModel(isEditProfile: true)
    @State private var isActive = false

    var body: some View {
        VStack(spacing: 20) {
            HeaderView()
            BodyView(viewModel: viewModel)
            PushView(destination: ProfileTabBar(), isActive: $isActive) {
                Button(action: {
                    self.viewModel.updateProfile { isUpdated in
                        if isUpdated {
                            isActive = true
                        }
                    }
                }, label: {
                    RoundButton("confirm".localized(), width: UIScreen.main.bounds.width - 40, height: 62, alignment: .center)
//                                .padding(.horizontal, 40)
                })
            }
            Spacer()
        }.onTapGesture {
            hideKeyboard()
        }
    }
    
    // MARK: - Header
    struct HeaderView: View {
        
        let imageHeight:CGFloat = UIScreen.main.bounds.width / 3
        var body: some View {
            VStack {
                LinearGradient(gradient: Gradient(colors: [.red, .red, .red.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
                    .frame(height: imageHeight - 20)
                Image("person")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageHeight, height: imageHeight, alignment: .center)
                    .cornerRadius(10)
                    .padding(.top, -(imageHeight - 20))
                Text("networking_title".localized())
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.horizontal, 60)
                    .padding(.vertical, 20)
                    .opacity(0.7)
            }
        }
    }
    
    // MARK: - Body
    struct BodyView: View {
                        
        @ObservedObject var viewModel: ProfileViewModel
        
        var body: some View {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    HStack {
                        if Configuration.isLanguageRTL {
                            Spacer()
                        }
                        Text("interests".localized())
                            .font(.footnote)
                            .fontWeight(.bold)
                        if !Configuration.isLanguageRTL {
                            Spacer()
                        }
                    }
                    TagView(tags: viewModel.tags)
                    inputFields(viewModel: viewModel)
                }
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    struct inputFields: View {
                        
        @ObservedObject var viewModel: ProfileViewModel

        var body: some View {
            VStack(spacing: 15) {
                TextFieldWithImage(text: $viewModel.firstNameText, placeholder: "first_name".localized(), imageName: "")
                TextFieldWithImage(text: $viewModel.LastNameText, placeholder: "last_name".localized(), imageName: "")
                TextFieldWithImage(text: $viewModel.jobTitleText, placeholder: "job title".localized(), imageName: "")
                TextFieldWithImage(text: $viewModel.educationFieldText, placeholder: "education".localized(), imageName: "")
//                TextFieldWithImage(text: $viewModel.phoneNumberText, placeholder: "phone number".localized(), imageName: "")
                TextFieldWithImage(text: $viewModel.emailText, placeholder: "email".localized(), imageName: "")
                TextView(text: $viewModel.biographyText)
                .font(.body)
                .frame(height: 100)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.gray)
                )
            }
        }
    }
}

//struct EditProfileView_Previews: PreviewProvider {
    
//    static var previews: some View {
//        EditProfileView(, loginSetting: Binding<LoginSetting>)
//    }
//}
