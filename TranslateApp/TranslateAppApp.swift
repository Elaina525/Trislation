//
//  TranslateAppApp.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 2/8/2023.
//

import SwiftUI

@main
struct TranslateAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var selectedTab: Int = 0
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, appDelegate.persistentContainer.viewContext)
        }
    }
}
