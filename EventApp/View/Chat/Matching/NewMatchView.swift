//
//  NewMatchView.swift
//  EventApp
//
//  Created by Alireza on 10/15/21.
//  Copyright © 2021 Alexani. All rights reserved.
//

import SwiftUI

struct MatchViewItem: View {
    
    @State var width: CGFloat = (UIScreen.main.bounds.width - 50)/2
    @State var image = UIImage()
    @State var title: String = ""
    @State var subtitle: String = ""
    @State var details: String = ""
    
    
    var body: some View {
            VStack(alignment: .center, spacing: 5) {
                let imageWidth = width * 0.47
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageWidth, height: imageWidth)
                    .cornerRadius(imageWidth/2)
                
                Text(title)
                    .bold()
                    .foregroundColor(Colors.textColor)

                
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(Colors.textColor)

                Text(details)
                    .font(.footnote)
                    .foregroundColor(Colors.textColor)
            }
            .padding(15)
            .frame(width: width, height: 1.5*width, alignment: .center)
            .background(Colors.primaryBackground)
            .cornerRadius(7)
            .shadow(color: Color(.lightGray).opacity(0.3), radius: 7, x: 0, y: 0)
    }
}

struct NewMatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchViewItem(width: 180, image: UIImage(named: "plus")!, title: "", subtitle: "", details: "")
    }
}
