//
//  EntitySchema.swift
//  Kinvey
//
//  Created by Victor Barros on 2016-03-01.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import Foundation
import ObjectiveC

@objc(KNVEntitySchema)
internal class EntitySchema: NSObject {
    
    static var entitySchemas = [String : EntitySchema]()
    
    internal let persistableType: Persistable.Type
    internal let anyClass: AnyClass
    internal let collectionName: String
    
    internal typealias ClassType = ((String, String?), (AnyClass, AnyClass?))
    internal let properties: [String : ClassType]
    
    class func entitySchema<T: Persistable>(type: T.Type) -> EntitySchema? {
        return entitySchemas[NSStringFromClass(type)]
    }
    
    internal class func entitySchema(type: AnyClass) -> EntitySchema? {
        return entitySchemas[NSStringFromClass(type)]
    }
    
    class func scanForPersistableEntities() {
        var classCount = UInt32(0)
        let classList = objc_copyClassList(&classCount)
        for var i = UInt32(0); i < classCount; i++ {
            if let aClass = classList[Int(i)] as AnyClass? where class_conformsToProtocol(aClass, Persistable.self),
                let cls = aClass as? Persistable.Type
            {
                entitySchemas[NSStringFromClass(aClass)] = EntitySchema(persistableType: cls, anyClass: aClass, collectionName: cls.kinveyCollectionName(), properties: getProperties(aClass))
            }
        }
    }
    
    private class func getProperties(cls: AnyClass) -> [String : ClassType] {
        let regexClassName = try! NSRegularExpression(pattern: "@\"(\\w+)(?:<(\\w+)>)?\"", options: [])
        var propertyCount = UInt32(0)
        let properties = class_copyPropertyList(cls, &propertyCount)
        defer { free(properties) }
        var map = [String : ClassType]()
        for var i = UInt32(0); i < propertyCount; i++ {
            let property = properties[Int(i)]
            if let propertyName = String.fromCString(property_getName(property)) {
                var attributeCount = UInt32(0)
                let attributes = property_copyAttributeList(property, &attributeCount)
                defer { free(attributes) }
                attributeLoop : for var x = UInt32(0); x < attributeCount; x++ {
                    let attribute = attributes[Int(x)]
                    if let attributeName = String.fromCString(attribute.name) where attributeName == "T",
                        let attributeValue = String.fromCString(attribute.value),
                        let textCheckingResult = regexClassName.matchesInString(attributeValue, options: [], range: NSMakeRange(0, attributeValue.characters.count)).first
                    {
                        let attributeValueNSString = attributeValue as NSString
                        let propertyTypeName = attributeValueNSString.substringWithRange(textCheckingResult.rangeAtIndex(1))
                        let propertySubTypeName: String?
                        if textCheckingResult.numberOfRanges > 2 {
                            let range = textCheckingResult.rangeAtIndex(2)
                            propertySubTypeName = range.location != NSNotFound ? attributeValueNSString.substringWithRange(range) : nil
                        } else {
                            propertySubTypeName = nil
                        }
                        let anyClassType: AnyClass = NSClassFromString(propertyTypeName)!
                        let anyClassSubType: AnyClass? = propertySubTypeName != nil ? NSClassFromString(propertySubTypeName!) : nil
                        map[propertyName] = (
                            (propertyTypeName, propertySubTypeName),
                            (anyClassType, anyClassSubType)
                        )
                        break attributeLoop
                    }
                }
            }
        }
        return map
    }
    
    init(persistableType: Persistable.Type, anyClass: AnyClass, collectionName: String, properties: [String : ClassType]) {
        self.persistableType = persistableType
        self.anyClass = anyClass
        self.collectionName = collectionName
        self.properties = properties
    }
    
}