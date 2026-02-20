//
//  ICAMApp.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/22.
//

import SwiftUI

@main
struct ICAMApp: App
{
    let persistenceController=PersistenceController.shared
    
    var body: some Scene
    {
        WindowGroup
        {
            IntroView()
                .environment(\.managedObjectContext, self.persistenceController.container.viewContext)
                .preferredColorScheme(.light)
        }
    }
}
