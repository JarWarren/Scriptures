//
//  TestamentKeys.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/18/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation

struct TestamentKeys {
    
    static let BoM = "book-of-mormon"
    static let PoGP = "pearl-of-great-price"
    static let DaC = "doctrine-and-covenants"
    static let NT = "new-testament"
    static let OT = "old-testament"
    
    static let reverseSelectedTestament = ["book-of-mormon" : 0,
                                           "pearl-of-great-price" : 1,
                                           "doctrine-and-covenants" : 2,
                                           "new-testament" : 3,
                                           "old-testament" : 4]
    
    static let dictionary = [0 : "Book of Mormon",
                             1 : "Pearl of Great Price",
                             2 : "Doctrine and Covenants",
                             3 : "New Testament",
                             4 : "Old Testament"]
    
    static let chapters = [
        0 : 239.0, // BoM
        1 : 19.0, // PoGP
        2 : 138.0, // D&C
        3 : 260.0, // NT
        4 : 929.0] // OT
}
