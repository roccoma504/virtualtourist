//
//  UrlArray.swift
//  virtualtourist
//
//  Created by Matthew Rocco on 12/15/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation

struct UrlArray {
    private var urlArray = [NSURL]()
    
    mutating func appendUrl(url : NSURL) {
        urlArray.append(url)
    }
    
    func urls() -> [NSURL] {
        return urlArray
    }
}
