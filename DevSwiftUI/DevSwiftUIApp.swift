//
//  DevSwiftUIApp.swift
//  DevSwiftUI
//
//  Created by hima sai on 25/03/22.
//

import SwiftUI
import Firebase

@main
struct DevSwiftUIApp: App {
    
    init() {
    FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
