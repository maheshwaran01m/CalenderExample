//
//  EventFormViewModel.swift
//  CalenderExample
//
//  Created by MAHESHWARAN on 16/02/24.
//

import SwiftUI

class EventFormViewModel: ObservableObject {
  
  @Published var date = Date()
  @Published var note = ""
  @Published var eventType = Event.EventType.unspecified
  
  var id: String?
  var updating: Bool { id != nil }
  
  init() {}
  
  init(_ event: Event) {
    date = event.date
    note = event.note
    eventType = event.eventType
    id = event.id
  }
  
  var incomplete: Bool {
    note.isEmpty
  }
}
