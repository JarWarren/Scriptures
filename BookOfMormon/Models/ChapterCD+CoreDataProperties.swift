//
//  ChapterCD+CoreDataProperties.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/31/18.
//  Copyright © 2018 Warren. All rights reserved.
//
//

import Foundation
import CoreData


extension ChapterCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChapterCD> {
        return NSFetchRequest<ChapterCD>(entityName: "ChapterCD")
    }

    @NSManaged public var chapter: Int64
    @NSManaged public var reference: String?
    @NSManaged public var book: BooksCD?
    @NSManaged public var verses: NSSet?

}

// MARK: Generated accessors for verses
extension ChapterCD {

    @objc(addVersesObject:)
    @NSManaged public func addToVerses(_ value: VerseCD)

    @objc(removeVersesObject:)
    @NSManaged public func removeFromVerses(_ value: VerseCD)

    @objc(addVerses:)
    @NSManaged public func addToVerses(_ values: NSSet)

    @objc(removeVerses:)
    @NSManaged public func removeFromVerses(_ values: NSSet)

}
