//
//  ScriptureDecodingController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/18/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation

class ScriptureController {
    
    static let shared = ScriptureController()
    private init() {}
    var decodedTestament: Testament?
    var decodedDoctrine: Doctrine?
    var selectedTestament: String?
    var currentBook = 0
    var currentChapter = 0
    
    func decode(testament: String) {
        
        self.selectedTestament = testament
        if let testamentPath = Bundle.main.path(forResource: testament, ofType: "json") {
            do {
                let testamentData = try Data(contentsOf: URL(fileURLWithPath: testamentPath))
                switch testament {
                case TestamentKeys.DaC:
                    let decodedDoctrine = try JSONDecoder().decode(Doctrine.self, from: testamentData)
                    self.decodedDoctrine = decodedDoctrine
                default:
                    let decodedTestament = try JSONDecoder().decode(Testament.self, from: testamentData)
                    self.decodedTestament = decodedTestament
                }
            } catch {
                print("TESTAMENT DECODING")
            }
        }
    }
    func decode(book: Int, inTestament: String) {
        
        self.selectedTestament = inTestament
        if let bookPath = Bundle.main.path(forResource: inTestament, ofType: "json") {
            do {
                let testamentData = try Data(contentsOf: URL(fileURLWithPath: bookPath))
                let testament = try JSONDecoder().decode(Testament.self, from: testamentData)
                self.decodedTestament = testament
            } catch {
                print("BOOK DECODING")
            }
        }
    }
}
