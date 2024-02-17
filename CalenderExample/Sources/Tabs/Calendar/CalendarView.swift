//
//  CalendarView.swift
//  CalenderExample
//
//  Created by MAHESHWARAN on 17/02/24.
//

import SwiftUI

struct CalendarView: UIViewRepresentable {
  
  @ObservedObject private var eventStore: EventStore
  
  init(for eventStore: ObservedObject<EventStore>) {
    _eventStore = eventStore
  }
  
  func makeUIView(context: Context) -> UICalendarView {
    let view = UICalendarView()
    view.calendar = Calendar(identifier: .gregorian)
    view.availableDateRange = eventStore.dateInterval
    return view
  }
  
  func updateUIView(_ uiView: UICalendarView, context: Context) {}
  
  // MARK: - Coordinator
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self, eventStore: _eventStore)
  }
  
  
  class Coordinator: NSObject, UICalendarViewDelegate {
    
    var parent: CalendarView
    @ObservedObject private var eventStore: EventStore
    
    init(_ parent: CalendarView, eventStore: ObservedObject<EventStore>) {
      self.parent = parent
      _eventStore = eventStore
    }
    
    func calendarView(_ calendarView: UICalendarView, 
                      decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
      nil
    }
  }
}
