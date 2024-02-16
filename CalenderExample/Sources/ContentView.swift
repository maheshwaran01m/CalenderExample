//
//  ContentView.swift
//  CalenderExample
//
//  Created by MAHESHWARAN on 16/02/24.
//

import SwiftUI

struct ContentView: View {
  
  @StateObject private var eventStore: EventStore
  
  init(_ preview: Bool = false) {
    _eventStore = .init(wrappedValue: .init(preview))
  }
  
  var body: some View {
    TabView {
      EventsListView(for: eventStore)
        .tabItem { Label("List", systemImage: "list.triangle") }
      
      EventsCalendarView(for: eventStore)
        .tabItem { Label("Calender", systemImage: "calendar") }
    }
  }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(true)
  }
}
