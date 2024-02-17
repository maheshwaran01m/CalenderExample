//
//  DaysEventsListView.swift
//  CalenderExample
//
//  Created by MAHESHWARAN on 17/02/24.
//

import SwiftUI

struct DaysEventsListView: View {
  
  @ObservedObject private var eventStore: EventStore
  @Binding var dateSelected: DateComponents?  
  @State private var formType: EventFormType?
  
  init(for eventStore: ObservedObject<EventStore>,
       dateSelection: Binding<DateComponents?>) {
    _eventStore = eventStore
    _dateSelected = dateSelection
  }
  
  var body: some View {
    NavigationStack {
      mainView
        .navigationTitle(dateSelected?.date?.formatted(date: .long, time: .omitted) ?? "")
    }
  }
  
  @ViewBuilder
  private var mainView: some View {
    if let dateSelected {
      let events = eventStore.events.filter { $0.date.startDate == dateSelected.date?.startDate }
      
      List(events) { event in
        listView(event)
      }
    }
  }
  
  func listView(_ event: Event) -> some View {
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
}

// MARK: - Preview

struct DaysEventsListView_Previews: PreviewProvider {
  
  static var dateComponents: DateComponents {
    var dateComponent = Calendar.current.dateComponents(
      [.month, .day, .year, .hour, .minute], from: Date())
    dateComponent.timeZone = .current
    dateComponent.calendar = Calendar(identifier: .gregorian)
    return dateComponent
  }
  
  static var previews: some View {
    DaysEventsListView(
      for: .init(initialValue: .init(true)),
      dateSelection: .constant(dateComponents))
  }
}
