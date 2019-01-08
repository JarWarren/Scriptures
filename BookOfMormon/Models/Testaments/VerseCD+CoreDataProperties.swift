//
//  VerseCD+CoreDataProperties.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/31/18.
//  Copyright © 2018 Warren. All rights reserved.
//
//

import Foundation
import CoreData


extension VerseCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VerseCD> {
        return NSFetchRequest<VerseCD>(entityName: "VerseCD")
    }

    @NSManaged public var verse: Int64
    @NSManaged public var text: String?
    @NSManaged public var reference: String?
    @NSManaged public var isHighlighted: Bool
    @NSManaged public var noteTitle: String?
    @NSManaged public var noteText: String?
    @NSManaged public var noteDate: Date?
    @NSManaged public var color: Int64
    @NSManaged public var chapter: ChapterCD?
    @NSManaged public var section: SectionCD?

}
