//
//  BooksCD+CoreDataProperties.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/31/18.
//  Copyright © 2018 Warren. All rights reserved.
//
//

import Foundation
import CoreData


extension BooksCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BooksCD> {
        return NSFetchRequest<BooksCD>(entityName: "BooksCD")
    }

    @NSManaged public var book: String?
    @NSManaged public var title: String?
    @NSManaged public var chapters: NSSet?
    @NSManaged public var testament: TestamentCD?

}

// MARK: Generated accessors for chapters
extension BooksCD {

    @objc(addChaptersObject:)
    @NSManaged public func addToChapters(_ value: ChapterCD)

    @objc(removeChaptersObject:)
    @NSManaged public func removeFromChapters(_ value: ChapterCD)

    @objc(addChapters:)
    @NSManaged public func addToChapters(_ values: NSSet)

    @objc(removeChapters:)
    @NSManaged public func removeFromChapters(_ values: NSSet)

}
