//
//  MatchingView.swift
//  EventApp
//
//  Created by Alireza on 10/15/21.
//  Copyright © 2021 Alexani. All rights reserved.
//

import SwiftUI

struct MatchingView: View {
    
    @ObservedObject var viewModel = MatchingViewModel()
    
    var body: some View {
        GeometryReader { geo in
            let spacing: CGFloat = 8
            if self.viewModel.statusView == .complete {
                GridStackView(minCellWidth: (geo.size.width  - spacing)/2 - 32, spacing: spacing, numItems: viewModel.repositories.count + 1, alignment: .center) { index, cellWidth in
                    if index == 0 {
                        MatchViewItem(width: cellWidth, image: UIImage(named: "plus")!, title: "search_person_title".localized(), subtitle: "search_person_subtitle".localized(), details: "")
                    } else {
                        MatchViewItem()
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }else if self.viewModel.statusView == .loading{
                Indicator()
                    .frame(width: geo.size.width, height: geo.size.height)
            }else if self.viewModel.statusView == .error {
                ErrorView(errorText: self.viewModel.errorMessage)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .onTapGesture {
                        self.viewModel.setup()
                    }
            }
        }
    }
}

struct MatchingView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingView()
    }
}
