//
//  EventFormView.swift
//  CalenderExample
//
//  Created by MAHESHWARAN on 16/02/24.
//

import SwiftUI

struct EventFormView: View {
  
  @ObservedObject private var eventStore: EventStore
  @StateObject private var viewModel: EventFormViewModel
  
  @Environment(\.dismiss) var dismiss
  @FocusState private var focus: Bool
  
  init(for store: ObservedObject<EventStore>) {
    _eventStore = store
    _viewModel = .init(wrappedValue: .init())
  }
  
  var body: some View {
    NavigationStack {
      VStack(alignment: .leading, spacing: 0) {
        mainView
      }
      .navigationTitle(viewModel.updating ? "Update Event" : "New Event")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar(content: closeButton)
    }
  }
  
  var mainView: some View {
    Form {
      TextField("Note", text: $viewModel.note, axis: .vertical)
        .focused($focus, equals: true)
      
      DatePicker(selection: $viewModel.date) {
        Text("Date & Time")
      }
      
      Picker("Event type", selection: $viewModel.eventType) {
        ForEach(Event.EventType.allCases) { type in
          Text(type.icon + " " + type.rawValue.capitalized)
            .tag(type)
        }
      }
      
      buttonView
    }
  }
  
  var buttonView: some View {
    Section {
      Button(action: addEvents) {
        Text("\(viewModel.updating ? "Edit" : "Add") Event")
      }
      .buttonStyle(.borderedProminent)
      .frame(maxWidth: .infinity)
    }
    .listRowBackground(Color.clear)
  }
  
  func addEvents() {
    if viewModel.updating {
      let event = Event(
        viewModel.id ?? "",
        eventType: viewModel.eventType,
        date: viewModel.date,
        note: viewModel.note)
      
      eventStore.update(event)
    } else {
      eventStore.add(.init(eventType: viewModel.eventType,
                           date: viewModel.date,
                           note: viewModel.note))
    }
    
    dismiss()
  }
  
  @ToolbarContentBuilder
  func closeButton() -> some ToolbarContent {
    ToolbarItem(placement: .topBarTrailing) {
      Button {
        dismiss()
      } label: {
        Image(systemName: "xmark.circle")
          .imageScale(.large)
          .font(.title2)
          .foregroundStyle(Color.secondary, Color.gray.opacity(0.5))
      }
    }
  }
}

extension EventFormView {
  
  init(for store: ObservedObject<EventStore>, event: Event) {
    _eventStore = store
    _viewModel = .init(wrappedValue: .init(event))
  }
}

// MARK: - Preview

struct EventFormView_Previews: PreviewProvider {
  
  static var previews: some View {
    EventFormView(for: .init(initialValue: .init(true)))
      .environmentObject(EventStore())
  }
}

