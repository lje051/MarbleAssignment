//
//  MyFavorite+CoreDataProperties.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/11.
//
//

import Foundation
import CoreData


extension MyFavorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyFavorite> {
        return NSFetchRequest<MyFavorite>(entityName: "MyFavorite")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var thumbnailExtension: String?
    @NSManaged public var path: String?
    @NSManaged public var isSelected: Bool

}

extension MyFavorite : Identifiable {

}
