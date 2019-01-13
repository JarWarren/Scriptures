//
//  VerseCD+CoreDataClass.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/31/18.
//  Copyright © 2018 Warren. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VerseCD)
public class VerseCD: NSManagedObject {

}


extension VerseCD {
    
    convenience init(dictionary: [String : Any], chapter: ChapterCD?, section: SectionCD?) {
        self.init(context: CoreDataStack.managedObjectContext)
        guard let verse = dictionary["verse"] as? Int,
        let reference = dictionary["reference"] as? String,
        let text = dictionary["text"] as? String
        else { return }
        
        self.verse = Int64(verse)
        self.reference = reference
        self.text = text
        self.chapter = chapter
        self.section = section
    }
}
