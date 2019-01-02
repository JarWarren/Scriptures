//
//  SectionCD+CoreDataProperties.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/2/19.
//  Copyright © 2019 Warren. All rights reserved.
//
//

import Foundation
import CoreData


extension SectionCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SectionCD> {
        return NSFetchRequest<SectionCD>(entityName: "SectionCD")
    }

    @NSManaged public var section: Int64
    @NSManaged public var reference: String?
    @NSManaged public var verses: NSOrderedSet?
    @NSManaged public var doctrine: DoctrineCD?

}

// MARK: Generated accessors for verses
extension SectionCD {

    @objc(insertObject:inVersesAtIndex:)
    @NSManaged public func insertIntoVerses(_ value: VerseCD, at idx: Int)

    @objc(removeObjectFromVersesAtIndex:)
    @NSManaged public func removeFromVerses(at idx: Int)

    @objc(insertVerses:atIndexes:)
    @NSManaged public func insertIntoVerses(_ values: [VerseCD], at indexes: NSIndexSet)

    @objc(removeVersesAtIndexes:)
    @NSManaged public func removeFromVerses(at indexes: NSIndexSet)

    @objc(replaceObjectInVersesAtIndex:withObject:)
    @NSManaged public func replaceVerses(at idx: Int, with value: VerseCD)

    @objc(replaceVersesAtIndexes:withVerses:)
    @NSManaged public func replaceVerses(at indexes: NSIndexSet, with values: [VerseCD])

    @objc(addVersesObject:)
    @NSManaged public func addToVerses(_ value: VerseCD)

    @objc(removeVersesObject:)
    @NSManaged public func removeFromVerses(_ value: VerseCD)

    @objc(addVerses:)
    @NSManaged public func addToVerses(_ values: NSOrderedSet)

    @objc(removeVerses:)
    @NSManaged public func removeFromVerses(_ values: NSOrderedSet)

}
