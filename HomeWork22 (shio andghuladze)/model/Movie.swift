//
//  Movie.swift
//  HomeWork22 (shio andghuladze)
//
//  Created by shio andghuladze on 13.08.22.
//

import Foundation

struct Movies: Codable {
    let results: [Movie]
}

struct Movie: Codable{
    let id: Int
    let name: String
    let overview: String
    let poster_path: String
}
