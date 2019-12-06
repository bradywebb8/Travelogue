//
//  Note+CoreDataProperties.swift
//  TravelogProject
//
//  Created by Brady Webb on 12/5/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var body: String?
    @NSManaged public var rawAddDate: Date?
    @NSManaged public var rawImage: Data?
    @NSManaged public var title: String?

}
