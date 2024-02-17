//
//  EventsListView.swift
//  CalenderExample
//
//  Created by MAHESHWARAN on 16/02/24.
//

import SwiftUI

struct EventsListView: View {
  
  @ObservedObject private var eventStore: EventStore
  @State private var formType: EventFormType?
  
  init(for store: EventStore) {
    _eventStore = .init(wrappedValue: store)
  }
  
  var body: some View {
    NavigationStack {
      List(eventStore.events.sorted(by: <)) { event in
        mainView(event)
      }
      .toolbar(content: addButton)
      .navigationTitle("Calendar Events")
    }
  }
  
  func mainView(_ event: Event) -> some View {
    HStack {
      VStack(alignment: .leading) {
        
        HStack {
          Text(event.eventType.icon)
            .font(.title)
          
          Text(event.note)
        }
        
        Text(event.date.formatted(date: .abbreviated, time: .shortened))
          .foregroundStyle(Color.secondary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      Button {
        formType = .update(_eventStore, event)
      } label: {
        Text("Edit")
      }
      .buttonStyle(.bordered)
    }
    .swipeActions {
      Button(role: .destructive) {
        eventStore.delete(event)
      } label: {
        Image(systemName: "trash")
      }
    }
    .sheet(item: $formType) { $0 }
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

struct EventsListView_Previews: PreviewProvider {
  
  static var previews: some View {
    NavigationStack {
      EventsListView(for: .init(true))
    }
  }
}
