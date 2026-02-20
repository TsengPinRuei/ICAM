//
//  Persistence.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/31.
//

import CoreData

//ImageToImage -> image: BinaryData, time: Date
//TextToImage -> image: BinaryData,textC: String, textE: String, time: Date
struct PersistenceController
{
    static let shared=PersistenceController()
    let container: NSPersistentContainer
    
    static var preview: PersistenceController =
    {
        let result=PersistenceController(inMemory: true)
        let viewContext=result.container.viewContext
        
        for _ in 0..<10
        {
            //let newItem=Item(context: viewContext)
            //newItem.timestamp=Date()
        }
        
        do
        {
            try viewContext.save()
        }
        catch
        {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application,
            // although it may be useful during development.
            let nsError=error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()
    
    init(inMemory: Bool=false)
    {
        self.container=NSPersistentContainer(name: "History")
        
        if inMemory
        {
            self.container.persistentStoreDescriptions.first!.url=URL(fileURLWithPath: "/dev/null")
        }
        
        self.container.loadPersistentStores
        {(storeDescription, error) in
            if let error=error as NSError?
            {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                // although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        self.container.viewContext.automaticallyMergesChangesFromParent=true
    }
}
