//
//  CalendarView.swift
//  CalenderExample
//
//  Created by MAHESHWARAN on 17/02/24.
//

import SwiftUI

struct CalendarView: UIViewRepresentable {
  
  @ObservedObject private var eventStore: EventStore
  @Binding var dateSelected: DateComponents?
  @Binding var displayEvents: Bool
  
  init(for eventStore: ObservedObject<EventStore>,
       dateSelection: Binding<DateComponents?>,
       displayEvents: Binding<Bool>) {
    _eventStore = eventStore
    _dateSelected = dateSelection
    _displayEvents = displayEvents
  }
  
  func makeUIView(context: Context) -> UICalendarView {
    let view = UICalendarView()
    view.delegate = context.coordinator
    
    view.calendar = Calendar(identifier: .gregorian)
    view.availableDateRange = eventStore.dateInterval
    let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
    view.selectionBehavior = dateSelection
    
    return view
  }
  
  func updateUIView(_ uiView: UICalendarView, context: Context) {
    if let changedEvent = eventStore.changedEvent {
      uiView.reloadDecorations(forDateComponents: [changedEvent.dateComponents], animated: true)
      eventStore.changedEvent = nil
    }
    
    if let movedEvent = eventStore.movedEvent {
      uiView.reloadDecorations(forDateComponents: [movedEvent.dateComponents], animated: true)
      eventStore.movedEvent = nil
    }
  }
  
  // MARK: - Coordinator
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self, eventStore: _eventStore)
  }
  
  
  class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    var parent: CalendarView
    @ObservedObject private var eventStore: EventStore
    
    init(_ parent: CalendarView, eventStore: ObservedObject<EventStore>) {
      self.parent = parent
      _eventStore = eventStore
    }
    
    @MainActor
    func calendarView(_ calendarView: UICalendarView,
                      decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
      let events = eventStore.events.filter { $0.date.startDate == dateComponents.date?.startDate }
      
      guard !events.isEmpty else { return nil }
      
      if events.count > 1 {
        return .image(UIImage(systemName: "doc.on.doc.fill"), color: .red, size: .large)
      } else if let singleEvent = events.first {
        
        return .customView {
          let icon = UILabel()
          icon.text = singleEvent.eventType.icon
          
          return icon
        }
      }
      return nil
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate,
                       didSelectDate dateComponents: DateComponents?) {
      guard let dateComponents else { return }
      parent.dateSelected = dateComponents
      
      let events = eventStore.events.filter { $0.date.startDate == dateComponents.date?.startDate }
      
      guard !events.isEmpty else { return }
      
      parent.displayEvents.toggle()
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, 
                       canSelectDate dateComponents: DateComponents?) -> Bool {
      return true
    }
  }
}
