//
//  CalenderExampleApp.swift
//  CalenderExample
//
//  Created by MAHESHWARAN on 16/02/24.
//

import SwiftUI

@main
struct CalenderExampleApp: App {
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .onAppear { print("Path: \(URL.libraryDirectory.path())") }
    }
  }
}
