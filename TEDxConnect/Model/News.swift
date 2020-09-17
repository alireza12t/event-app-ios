//
//  News.swift
//  TEDxConnect
//
//  Created by Tadeh Alexani on 8/28/20.
//  Copyright © 2020 Alexani. All rights reserved.
//

import Foundation

struct News: Decodable, Hashable {
  
  var title: String
  var description: String
  var icon: String?
  
  static var example: News {
    News(title: "-", description: "-", icon: Images.newsIconExample)
  }
}

struct NewsResponse: Decodable {
  var allNews: [News]
}
