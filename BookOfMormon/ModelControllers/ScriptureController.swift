//
//  ScriptureDecodingController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/18/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation
import CoreData

class ScriptureController {
    
    static let shared = ScriptureController()
    private init() {}
    var fetchedTestament: TestamentCD?
    var fetchedDoctrine: DoctrineCD?
    var selectedTestament: String?
    var currentBook = 0
    var currentChapter = 0
    var bookmark: Double?
    
    func decode(testament: String) {
        
        self.selectedTestament = testament
        var keepDecoding = true
        
        change(testament: testament) { (alreadyDecoded) in
            if alreadyDecoded == true {
                keepDecoding = false
            }
        }
        
        guard keepDecoding == true else { return }
        
        if let testamentPath = Bundle.main.path(forResource: testament, ofType: "json") {
            
            switch testament {
                
            case TestamentKeys.DaC :
                
                do {
                    let doctrineData = try Data(contentsOf: URL(fileURLWithPath: testamentPath))
                    let doctrineDictionary = try JSONSerialization.jsonObject(with: doctrineData, options: .allowFragments) as! [String : Any]
                    let doctrineCoreData = DoctrineCD(dictionary: doctrineDictionary)
                    guard let allSections = doctrineCoreData.sections?.array as? [[String : Any]] else { return }
                    for sectionDictionary in allSections {
                        let section = SectionCD(dictionary: sectionDictionary, doctrine: doctrineCoreData)
                        section.doctrine = doctrineCoreData
                        for verseDictionary in section.versesTemp! {
                            let verse = VerseCD(dictionary: verseDictionary, chapter: nil, section: section)
                            verse.section = section
                        }
                    }
                    
                } catch {
                    
                }
                
            default :
                
                do {
                    let testamentData = try Data(contentsOf: URL(fileURLWithPath: testamentPath))
                    let testamentDictionary = try JSONSerialization.jsonObject(with: testamentData, options: .allowFragments) as! [String : Any]
                    let testamentCoreData = TestamentCD(dictionary: testamentDictionary)
                    
                    guard let bookDictionaries = testamentDictionary["books"] as? [[String : Any]] else { return }
                    
                    for bookDictionary in bookDictionaries {
                        let book = BooksCD(dictionary: bookDictionary, testament: testamentCoreData)
                        book.testament = testamentCoreData
                        for chapterDictionary in book.chaptersTemp! {
                            let chapter = ChapterCD(dictionary: chapterDictionary, book: book)
                            chapter.book = book
                            for verseDictionary in chapter.versesTemp! {
                                let verse = VerseCD(dictionary: verseDictionary, chapter: chapter, section: nil)
                                verse.chapter = chapter
                            }
                        }
                    }
                    
                    self.fetchedTestament = testamentCoreData
                    
                    do {
                        try CoreDataStack.managedObjectContext.save()
                    } catch {
                        print("Failed to save MOC")
                    }
                    
                } catch {
                    print("Error decoding \(testament.capitalized)")
                }
                
                //
                //                switch testament {
                //                case TestamentKeys.DaC:
                //                    let decodedDoctrine = try JSONDecoder().decode(Doctrine.self, from: testamentData)
                //                    self.decodedDoctrine = decodedDoctrine
                //                default:
                //                    let decodedTestament = try JSONDecoder().decode(Testament.self, from: testamentData)
                //                    self.decodedTestament = decodedTestament
                //                }
            }
        }
    }
    
    func change(testament: String, completion: @escaping (Bool) -> Void) {
        
        var testamentTitle = testament
        self.selectedTestament = testament
        var decodingDoctrineAndCovenants = false
        switch testamentTitle {
            
        case TestamentKeys.DaC :
            decodingDoctrineAndCovenants = true
            let fetchRequest: NSFetchRequest <DoctrineCD> = DoctrineCD.fetchRequest()
            let predicate = NSPredicate(format: "title == %@", "The Doctrine and Covenants")
            fetchRequest.predicate = predicate
            do {
                let fetchedDoctrines = try CoreDataStack.managedObjectContext.fetch(fetchRequest)
                if fetchedDoctrines.first != nil {
                    self.fetchedDoctrine = fetchedDoctrines.first
                    completion(true)
                } else {
                      print("Beginning decode for THE DOCTRINE AND COVENANTS")
                    completion(false)
                }
            } catch {
                print("Beginning decode for THE DOCTRINE AND COVENANTS")
                completion(false)
            }
        case TestamentKeys.PoGP :
            if let newTitle = TestamentKeys.dictionary[1] {
                testamentTitle = "The " + newTitle
            }
        case TestamentKeys.NT :
            if let newTitle = TestamentKeys.dictionary[3] {
                testamentTitle = "The " + newTitle
            }
        case TestamentKeys.OT :
            if let newTitle = TestamentKeys.dictionary[4] {
                testamentTitle = "The " + newTitle
            }
        default :
            if let newTitle = TestamentKeys.dictionary[0] {
                testamentTitle = "The " + newTitle
            }
        }
        guard decodingDoctrineAndCovenants == false else { return }
        let fetchRequest: NSFetchRequest <TestamentCD> = TestamentCD.fetchRequest()
        let predicate = NSPredicate(format: "title == %@", testamentTitle)
        fetchRequest.predicate = predicate
        
        do {
            let fetchedTestaments = try CoreDataStack.managedObjectContext.fetch(fetchRequest)
            self.fetchedTestament = fetchedTestaments.first
            completion(true)
        } catch {
            print("Beginning decode for \(testament.capitalized)")
            completion(false)
        }
    }
}
