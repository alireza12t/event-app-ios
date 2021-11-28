//
//  ProfileView.swift
//  EventApp
//
//  Created by ali on 4/14/21.
//  Copyright © 2021 Alexani. All rights reserved.
//

import SwiftUI
import NavigationStack

struct ProfileView: View {
    
    @ObservedObject var viewModel = ProfileViewModel(shouldSetup: false)
    @State private var isActive = false

    var userId: String
    var leadingTrailingPadding: CGFloat = 40
    var isMyProfile: Bool = true
    
    init(viewModel: ProfileViewModel, isMyProfile: Bool, userId: String) {
        if viewModel.repositories?.id == nil {
            self.viewModel = ProfileViewModel()
        } else {
            self.viewModel = viewModel
        }
        self.userId = userId
        self.isMyProfile = isMyProfile
    }
    
    var body: some View {
        let width = UIScreen.main.bounds.width
        let imageHeight = width/3
            if self.viewModel.statusView == .complete {
                ScrollView(showsIndicators: false) {
                        VStack {
                            LinearGradient(gradient: Gradient(colors: [.red, .red, .red.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
                                .frame(width: width, height: imageHeight - 20)
                            Image("person")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: imageHeight, height: imageHeight, alignment: .center)
                                .cornerRadius(10)
                                .padding(.top, -(imageHeight - 20))
                        }
                            .frame(width: width)
                        
                        VStack(spacing: 20) {
                            Text(viewModel.firstName + " " + viewModel.lastName)
                                .font(.footnote)
                                .bold()
                            
                            TagView(tags: viewModel.interestList.compactMap({TagViewItem(title: $0.name, isSelected: true)}))
                                .disabled(true)
                            
                            HStack {
                                Text("Job Title".localized() + ": ")
                                    .font(.footnote)
                                    .bold()
                                
                                Text(viewModel.jobTitle.normalNumber)
                                    .customFont(name: Configuration.shabnamBold, style: .headline, weight: .regular)
                                Spacer()
                            }
                            
                            HStack {
                                Text("Field".localized() + ": ")
                                    .font(.footnote)
                                    .bold()
                                
                                Text(viewModel.educationField.normalNumber)
                                    .customFont(name: Configuration.shabnamBold, style: .headline, weight: .regular)
                                Spacer()
                            }
                            
                            HStack {
                                Text("My Story".localized())
                                    .font(.footnote)
                                    .bold()
                                Spacer()
                            }
                            
                            Text(viewModel.biography.normalNumber)
                                .customFont(name: Configuration.shabnam, style: .subheadline, weight: .regular)
                            
                            HStack(alignment: .center, spacing: 20) {
                                HStack {
                                    Image(systemName: "phone")
                                        .foregroundColor(Colors.textColor)
                                    
                                    LocalizedNumberText(viewModel.phoneNumber)
                                        .customFont(name: Configuration.shabnam, style: .subheadline, weight: .regular)
                                    
                                }
                                
                                HStack {
                                    Image(systemName: "envelope")
                                        .foregroundColor(Colors.textColor)
                                    Text(viewModel.email)
                                        .customFont(name: Configuration.shabnam, style: .subheadline, weight: .regular)
                                }
                            }
                            .padding()
                            
                            PushView(destination: EditProfileView(viewModel: viewModel), isActive: $isActive) {
                                Button(action: {
                                    self.isActive.toggle()
                                }, label: {
                                    if isMyProfile {
                                        RoundButton("Update Profile".localized(), width: width - 40, height: 62, alignment: .center)
                                    } else {
                                        RoundButton("Chat With".localized() + " " + viewModel.firstName, width: width - 40, height: 62, alignment: .center)
                                    }
                                })
                            }
                        }
                        .padding(20)
                    
                }
            }else if self.viewModel.statusView == .loading{
                Indicator()
            }else if self.viewModel.statusView == .error {
                ErrorView(errorText: self.viewModel.errorMessage)
                    .onTapGesture {
                        self.viewModel.setup()
                    }
            }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(), isMyProfile: false, userId: "1")
            .previewDevice("iPhone 12 mini")
        ProfileView(viewModel: ProfileViewModel(), isMyProfile: true, userId: "1")
    }
}
