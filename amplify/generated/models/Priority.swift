// swiftlint:disable all
import Amplify
import Foundation

public enum Priority: String, EnumPersistable {
  case low = "LOW"
  case medium = "MEDIUM"
  case high = "HIGH"
}