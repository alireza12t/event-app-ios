//
//  NotFoundView.swift
//  EventApp
//
//  Created by Alireza on 10/15/21.
//  Copyright © 2021 Alexani. All rights reserved.
//

import SwiftUI

struct NotFoundView: View {
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("not_found_chat".localized())
                    .customFont(name: Configuration.shabnam, size: 25, weight: .regular)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(30)
                
                LottieView(name: "404", loopMode: .loop)
                    .frame(width: UIScreen.main.bounds.width, height: 300)
                
                RoundButton("try_again".localized(), width: geo.size.width - 40, height: 62, alignment: .center)
                    .customFont(name: Configuration.shabnam, style: .headline, weight: .regular)
                    .onTapGesture(count: 1, perform: {
                        #warning("Add Action")
                    })
            }
        }
    }
}

struct NotFoundView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
