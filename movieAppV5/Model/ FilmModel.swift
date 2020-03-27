//
//   FilmModel.swift
//  movieAppV5
//
//  Created by Leonardo Diaz on 3/5/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation

struct FilmModel: Codable {
    let results: [Results]
}

struct Results: Codable {
    let poster_path: String?
    let overview: String
    let title: String
    let id: Int
}
 
