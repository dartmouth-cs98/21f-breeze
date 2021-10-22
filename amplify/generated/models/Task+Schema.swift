// swiftlint:disable all
import Amplify
import Foundation

extension Task {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case description
    case priority
    case status
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let task = Task.keys
    
    model.pluralName = "Tasks"
    
    model.fields(
      .id(),
      .field(task.title, is: .required, ofType: .string),
      .field(task.description, is: .optional, ofType: .string),
      .field(task.priority, is: .optional, ofType: .enum(type: Priority.self)),
      .field(task.status, is: .optional, ofType: .string),
      .field(task.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(task.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}