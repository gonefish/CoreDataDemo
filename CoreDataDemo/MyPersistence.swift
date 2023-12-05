//
//  CloudStore.swift
//  CoreDataDemo
//

import Foundation
import CoreData

class MyPersistentCloudKitContainer: NSPersistentCloudKitContainer {
    
//    override class func defaultDirectoryURL() -> URL {
//        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "xxx")!
//    }
    
    override func loadPersistentStores(completionHandler block: @escaping (NSPersistentStoreDescription, Error?) -> Void) {
        super.loadPersistentStores(completionHandler: block)
        
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        viewContext.automaticallyMergesChangesFromParent = true
    }
    
}

class MyInMemeryContainer: NSPersistentCloudKitContainer {
    
    override init(name: String, managedObjectModel model: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: model)
        
        persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        
        addPreviewData()
    }
    
    func addPreviewData() {
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
    }
    
}


final class MyPersistenceController {
    
    struct Configuration {
        
        let containerClass: NSPersistentCloudKitContainer.Type
        
        let name: String
        
        let managedObjectModel: NSManagedObjectModel?
        
        init(containerClass: NSPersistentCloudKitContainer.Type, name: String, managedObjectModel: NSManagedObjectModel? = nil) {
            self.containerClass = containerClass
            self.name = name
            self.managedObjectModel = managedObjectModel
        }
        
    }
    
    let container: NSPersistentCloudKitContainer
    
    init(_ configuration: MyPersistenceController.Configuration) {
        if let managedObjectModel = configuration.managedObjectModel {
            container = configuration.containerClass.init(name: configuration.name, managedObjectModel: managedObjectModel)
        } else {
            container = configuration.containerClass.init(name: configuration.name)
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
#if DEBUG
                fatalError("Unresolved error \(error), \(error.userInfo)")
#else
                
#endif
            }
        })
    }
    
}

extension MyPersistenceController {
    
    static var managedObjectModel: NSManagedObjectModel = {
        NSManagedObjectModel.mergedModel(from: [.main])!
    }()
    
    static var `default`: MyPersistenceController = {
        let configuration: MyPersistenceController.Configuration = .init(
            containerClass: MyPersistentCloudKitContainer.self,
            name: "CoreDataDemo",
            managedObjectModel: managedObjectModel)
        
        return MyPersistenceController(configuration)
    }()
    
    static var preview: MyPersistenceController = {
        MyPersistenceController(.init(containerClass: MyInMemeryContainer.self, name: "CoreDataDemo"))
    }()
    
}
