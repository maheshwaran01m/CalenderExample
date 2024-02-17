//
//  EventsCalendarView.swift
//  CalenderExample
//
//  Created by MAHESHWARAN on 16/02/24.
//

import SwiftUI

struct EventsCalendarView: View {
  @ObservedObject private var eventStore: EventStore
  
  init(for store: EventStore) {
    _eventStore = .init(wrappedValue: store)
  }
  
  var body: some View {
    NavigationStack {
      List {
        CalendarView(for: _eventStore)
          .listRowSeparator(.hidden)
          .navigationTitle("Calender View")
      }
      .listStyle(.plain)
    }
  }
}

// MARK: - Preview

struct EventsCalendarView_Previews: PreviewProvider {
  static var previews: some View {
    EventsCalendarView(for: .init(true))
  }
}
