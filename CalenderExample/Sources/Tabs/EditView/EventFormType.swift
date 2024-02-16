//
//  EventFormType.swift
//  CalenderExample
//
//  Created by MAHESHWARAN on 16/02/24.
//

import SwiftUI

enum EventFormType: Identifiable, View {
  
  case new(EventStore), update(EventStore, Event)
  
  var id: String {
    switch self {
    case .new: return "New"
    case .update: return "Update"
    }
  }
  
  var body: some View {
    switch self {
    case .new(let store): return EventFormView(for: store)
    case .update(let store, let event): return EventFormView(for: store, event: event)
    }
  }
}
