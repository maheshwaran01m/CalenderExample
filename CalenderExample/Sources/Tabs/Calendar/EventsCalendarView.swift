//
//  EventsCalendarView.swift
//  CalenderExample
//
//  Created by MAHESHWARAN on 16/02/24.
//

import SwiftUI

struct EventsCalendarView: View {
  
  @ObservedObject private var eventStore: EventStore
  @State private var dateSelected: DateComponents?
  @State private var displayEvents = false
  @State private var formType: EventFormType?
  
  init(for store: EventStore) {
    _eventStore = .init(wrappedValue: store)
  }
  
  var body: some View {
    NavigationStack {
      List {
        CalendarView(for: _eventStore, dateSelection: $dateSelected, displayEvents: $displayEvents)
          .listRowSeparator(.hidden)
          .navigationTitle("Calender View")
          .sheet(isPresented: $displayEvents) {
            DaysEventsListView(for: _eventStore,
                               dateSelection: $dateSelected)
            .presentationDetents([.medium, .large])
          }
          .toolbar(content: addButton)
          .sheet(item: $formType) { $0 }
      }
      .listStyle(.plain)
    }
  }
  
  @ToolbarContentBuilder
  func addButton() -> some ToolbarContent {
    ToolbarItem(placement: .topBarTrailing) {
      Button {
        formType = .new(_eventStore)
      } label: {
        Image(systemName: "plus.circle.fill")
          .imageScale(.large)
          .font(.title)
      }
    }
  }
}

// MARK: - Preview

struct EventsCalendarView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      EventsCalendarView(for: .init(true))
    }
  }
}
