//
//  TestamentStructures.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/18/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation

struct BookOfMormon {
    
    static let numberOfChapters = 239
    static let numberOfBooks = 15
    static let chaptersPerBook = ["1 Nephi" : 22,
                                  "2 Nephi" : 33,
                                  "Jacob" : 7,
                                  "Enos" : 1,
                                  "Jarom" : 1,
                                  "Omni" : 1,
                                  "Words of Mormon" : 1,
                                  "Mosiah" : 29,
                                  "Alma" : 63,
                                  "Helaman" : 16,
                                  "3 Nephi" : 30,
                                  "4 Nephi" : 1,
                                  "Mormon" : 9,
                                  "Ether" : 15,
                                  "Moroni" : 10]
    
    static let allBooks = ["1 Nephi",
                           "2 Nephi",
                           "Jacob",
                           "Enos",
                           "Jarom",
                           "Omni",
                           "Words of Mormon",
                           "Mosiah",
                           "Alma",
                           "Helaman",
                           "3 Nephi",
                           "4 Nephi",
                           "Mormon",
                           "Ether",
                           "Moroni"]
}

struct OldTestament {
    
    static let chapters = 929
    static let books = 39
}

struct NewTestament {
    
    static let chapters = 260
    static let books = 27
}

struct PearlOfGreatPrice {
    
    static let chapters = 19
    static let books = 5 // Didn't include facsimiles.
}

struct DoctrineAndCovenants {
    
    static let sections = 138
    static let books = 1 // Didn't include Official Declarations (total sections would be 140).
}
