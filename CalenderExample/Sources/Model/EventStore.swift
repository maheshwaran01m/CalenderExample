//
//  EventStore.swift
//  CalenderExample
//
//  Created by MAHESHWARAN on 16/02/24.
//

import SwiftUI

class EventStore: ObservableObject {
  
  @Published var events = [Event]()
  @Published var preview: Bool
  
  @Published var changedEvent: Event?
  @Published var movedEvent: Event?
  
  let dateInterval = DateInterval(start: .distantPast, end: .distantFuture)
  
  init(_ preview: Bool = false) {
    _preview = .init(wrappedValue: preview)
    fetchEvents()
  }
  
  func fetchEvents() {
    guard !preview else {
      events = Event.sampleEvents
      return
    }
    fetchData()
  }
  
  func delete(_ event: Event) {
    guard events.contains(where: { $0.id == event.id }),
          let index = events.firstIndex(of: event)  else { return }
    changedEvent = events.remove(at: index)
    saveData()
  }
  
  func add(_ event: Event) {
    events.append(event)
    changedEvent = event
    saveData()
  }
  
  func update(_ event: Event) {
    guard let index = events.firstIndex(where: { $0.id == event.id }) else {
      return
    }
    movedEvent = events[index]
    events[index].date = event.date
    events[index].note = event.note
    events[index].eventType = event.eventType
    changedEvent = event
    
    saveData()
  }
  
  // MARK: - Stor
}

// MARK: - Event

struct Event: Identifiable, Comparable {
  
  enum EventType: String, Identifiable, CaseIterable, Codable {
    case work, home, social, sport, unspecified
    
    var id: String { rawValue }
    
    var icon: String {
      switch self {
      case .work: return "🏦"
      case .home: return "🏡"
      case .social: return "🎉"
      case .sport: return "🏟"
      case .unspecified: return "📌"
      }
    }
  }
  
  var eventType: EventType
  var date: Date
  var note: String
  var id: String
  
  init(_ id: String = UUID().uuidString,
       eventType: EventType = .unspecified,
       date: Date, note: String) {
    self.eventType = eventType
    self.date = date
    self.note = note
    self.id = id
  }
  
  var dateComponents: DateComponents {
    var dateComponent = Calendar.current.dateComponents(
      [.month, .day, .year, .hour, .minute], from: date)
    dateComponent.timeZone = .current
    dateComponent.calendar = Calendar(identifier: .gregorian)
    return dateComponent
  }
  
  static var sampleEvents: [Event] {
    [
      Event(eventType: .home, date: Date().diff(numDays: 0), note: "Take notes"),
      Event(date: Date().diff(numDays: -1), note: "Update the notes"),
      Event(eventType: .home, date: Date().diff(numDays: 6), note: "Edit the notes"),
      Event(eventType: .social, date: Date().diff(numDays: 2), note: "Take a look edited notes"),
      Event(eventType: .work, date: Date().diff(numDays: -1), note: "Complete Editing notes"),
      Event(eventType: .sport, date: Date().diff(numDays: -3), note: "Plan for the Submit date for notes"),
      Event(date: Date().diff(numDays: -4), note: "Submit the notes on time")
    ]
  }
  
  static func < (lhs: Event, rhs: Event) -> Bool {
    lhs.date < rhs.date
  }
}

// MARK: - Date Extensions

extension Date {
  
  func diff(numDays: Int) -> Date {
    Calendar.current.date(byAdding: .day, value: numDays, to: self)!
  }
  
  var startDate: Date {
    Calendar.current.startOfDay(for: self)
  }
}
