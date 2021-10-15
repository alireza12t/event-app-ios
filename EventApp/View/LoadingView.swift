//
//  LoadingView.swift
//  EventApp
//
//  Created by Alireza on 8/12/21.
//  Copyright © 2021 Alexani. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("loading_chat".localized())
                    .customFont(name: Configuration.shabnam, size: 25, weight: .regular)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(30)
                
                LottieView(name: "cat", loopMode: .loop)
                    .frame(width: geo.size.width, height: 300)
                
                RoundButton("cancel_search".localized(), width: geo.size.width - 40, height: 62, alignment: .center)
                    .customFont(name: Configuration.shabnam, style: .headline, weight: .regular)
                    .onTapGesture(count: 1, perform: {
                        #warning("Add Action")
                    })
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
