//
//  StringExtensions.swift
//  HomeWork22 (shio andghuladze)
//
//  Created by shio andghuladze on 13.08.22.
//

import Foundation

extension Data {
    
    func toString()-> String{
        return String(data: self, encoding: .utf8) ?? ""
    }
    
}
