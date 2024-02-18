//
//  EventStoreExtensions.swift
//  CalenderExample
//
//  Created by MAHESHWARAN on 17/02/24.
//

import Foundation

extension EventStore {
  
  fileprivate var fileName: String { "eventStore.txt" }
  
  func saveData() {
    let documentURL = URL.documentsDirectory.appending(path: fileName)
    
    do {
      let data = try JSONEncoder().encode(events)
      try data.write(to: documentURL, options: .noFileProtection)
      fetchData()
    } catch {
      print("Unable to save events, reason: \(error.localizedDescription)")
    }
  }
  
  func fetchData() {
    guard isFileExist else { return }
    
    do {
      let documentURL = URL.documentsDirectory.appending(path: fileName)
      
      let data = try Data(contentsOf: documentURL)
      self.events = try JSONDecoder().decode([Event].self, from: data)
      
    } catch {
      print("Unable to fetch events, reason: \(error.localizedDescription)")
    }
  }
  
  fileprivate var isFileExist: Bool {
    FileManager.default.fileExists(atPath: URL.documentsDirectory.appending(path: fileName).path())
  }
}

// MARK: - Event

extension Event: Codable {
  
  enum CodingKeys: CodingKey {
    case eventType, date, note, id
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.date = try container.decode(Date.self, forKey: .date)
    self.eventType = try container.decode(EventType.self, forKey: .eventType)
    self.note = try container.decode(String.self, forKey: .note)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(note, forKey: .note)
    try container.encode(date, forKey: .date)
    try container.encode(eventType, forKey: .eventType)
  }
}
