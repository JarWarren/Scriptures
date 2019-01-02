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
    var fetchedTestament: TestamentCD?
    var decodedDoctrine: Doctrine?
    var selectedTestament: String?
    var currentBook = 0
    var currentChapter = 0
    var bookmark: Double?
    
    func decode(testament: String) {
        
        self.selectedTestament = testament
        if let testamentPath = Bundle.main.path(forResource: testament, ofType: "json") {
            do {
                let testamentData = try Data(contentsOf: URL(fileURLWithPath: testamentPath))
                let testamentDict = try JSONSerialization.jsonObject(with: testamentData, options: .allowFragments) as! [String : Any]
                
                // pass in the value to a convenience initalizer.
                let testament = TestamentCD(dictionary: testamentDict)
                
                guard let bookDictionaries = testamentDict["books"] as? [[String : Any]] else { return }
                
                for bookDict in bookDictionaries {
                    let book = BooksCD(dictionary: bookDict, testament: testament)
                    book.testament = testament
                    for chapterDict in book.chaptersTemp! {
                        let chapter = ChapterCD(dictionary: chapterDict, book: book)
                        chapter.book = book
                        for verseDict in chapter.versesTemp! {
                            let verse = VerseCD(dictionary: verseDict, chapter: chapter)
                            verse.chapter = chapter
                        }
                    }
                }
                self.fetchedTestament = testament
                
                //
                //                switch testament {
                //                case TestamentKeys.DaC:
                //                    let decodedDoctrine = try JSONDecoder().decode(Doctrine.self, from: testamentData)
                //                    self.decodedDoctrine = decodedDoctrine
                //                default:
                //                    let decodedTestament = try JSONDecoder().decode(Testament.self, from: testamentData)
                //                    self.decodedTestament = decodedTestament
                //                }
            } catch {
                print("TESTAMENT DECODING")
            }
        }
    }
    
//    func fetch(testament: String) {
//        
//        self.selectedTestament = testament
//        
//        do {
//            let fetchedTestamentCD = try CoreDataStack.managedObjectContext.fetch(TestamentCD)
//            _ = try JSONDecoder().decode(Testament.self, from: testamentData)
//            //                self.decodedTestament = testament
//        } catch {
//            print("BOOK DECODING")
//            
//        }
//    }
}
