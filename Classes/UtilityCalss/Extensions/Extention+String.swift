//
//  Extention+String.swift
//
//  Created by Apple on 23/11/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import Foundation


extension String {
    func secondsFromString (string: String) -> Int {
        var components: Array = string.components(separatedBy: ":")
        if components.count == 3 {
            var hours = components[0].intValue // components[0].toInt()!
            var minutes = components[1].intValue
            var seconds = components[2].intValue
            return Int((hours * 60 * 60) + (minutes * 60) + seconds)
        }
        
       return ((0 * 60 * 60) + (0 * 60) + 0)
        
    }
    func isEmptyOrWhitespace() -> Bool {
        
        if(self.isEmpty) {
            return true
        }
        return self.trimmingCharacters(in: (.whitespaces)).isEmpty
    }
}
