//
//  ScriptureDecoding.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/18/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation

struct Testament: Decodable { // BoM, NewTestament, OldTestament, PoGP or D&C.
    let title: String
    let books: [Book]
}

struct Book: Decodable {  // Books within the Bible, BoM, etc.
    let book: String
    let full_title: String
    let chapters: [Chapter]
}

struct Chapter: Decodable {
    let chapter: Int
    let reference: String
    let verses: [Verse]
}

struct Verse: Decodable {
    let verse: Int
    let reference: String
    let text: String
}
