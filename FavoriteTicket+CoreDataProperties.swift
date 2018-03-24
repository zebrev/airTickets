//
//  FavoriteTicket+CoreDataProperties.swift
//  
//
//  Created by Rapax on 23.03.2018.
//
//

import Foundation
import CoreData


extension FavoriteTicket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteTicket> {
        return NSFetchRequest<FavoriteTicket>(entityName: "FavoriteTicket")
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var departure: NSDate?
    @NSManaged public var expires: NSDate?
    @NSManaged public var returnDate: NSDate?
    @NSManaged public var airline: String?
    @NSManaged public var from: String?
    @NSManaged public var to: String?
    @NSManaged public var price: Int64
    @NSManaged public var flightNumber: Int16

}
