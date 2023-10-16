// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

import Foundation

public typealias FirebaseOptions = UnsafeMutablePointer<firebase.AppOptions>

extension firebase.AppOptions: CustomDebugStringConvertible {
  public var debugDescription: String {
    """
    AppOptions {
      package_name_: "\(String(cString: self.__package_nameUnsafe()))"
      api_key_: "\(String(cString: self.__api_keyUnsafe()))"
      app_id_: "\(String(cString: self.__app_idUnsafe()))"
      client_id_: "\(String(cString: self.__client_idUnsafe()))"
      database_url_: "\(String(cString: self.__database_urlUnsafe()))"
      ga_tracking_id_: "\(String(cString: self.__ga_tracking_idUnsafe()))"
      fcm_sender_id_: "\(String(cString: self.__messaging_sender_idUnsafe()))"
      storage_bucket_: "\(String(cString: self.__storage_bucketUnsafe()))"
      project_id_: "\(String(cString: self.__project_idUnsafe()))"
    }
    """
  }
}

extension FirebaseOptions {
  public static func defaultOptions() -> FirebaseOptions {
    guard let options = firebase.AppOptions.LoadDefault(nil) else {
      fatalError("unable to deserialise firebase options")
    }
    return options
  }

  public init?(contentsOfFile plistPath: String) {
    fatalError("\(#function) NYI")
    return nil
  }

  public init(googleAppID: String, gcmSenderID GCMSenderID: String) {
    self = .allocate(capacity: 1)
    self.initialize(to: firebase.AppOptions())
    self.googleAppID = googleAppID
    self.gcmSenderID = GCMSenderID
  }

  public var apiKey: String? {
    get {
      guard let value = self.pointee.__api_keyUnsafe() else { return nil }
      return String(cString: value)
    }
    set { self.pointee.set_api_key(newValue) }
  }

  public var bundleID: String {
    get {
      guard let value = self.pointee.__package_nameUnsafe() else {
        return Bundle.main.bundleIdentifier!
      }
      return String(cString: value)
    }
    set { self.pointee.set_package_name(newValue) }
  }

  public var clientID: String? {
    get {
      guard let value = self.pointee.__client_idUnsafe() else { return nil }
      return String(cString: value)
    }
    set { self.pointee.set_client_id(newValue) }
  }

  public var trackingID: String? {
    get {
      guard let value = self.pointee.__ga_tracking_idUnsafe() else {
        return nil
      }
      return String(cString: value)
    }
    set { self.pointee.set_ga_tracking_id(newValue) }
  }

  public var gcmSenderID: String {
    get { String(cString: self.pointee.__messaging_sender_idUnsafe()!) }
    set { self.pointee.set_messaging_sender_id(newValue) }
  }

  public var projectID: String? {
    get {
      guard let value = self.pointee.__project_idUnsafe() else { return nil }
      return String(cString: value)
    }
    set { self.pointee.set_project_id(newValue) }
  }

  @available(*, unavailable)
  public var androidClientID: String? { nil }

  public var googleAppID: String? {
    get {
      guard let value = self.pointee.__app_idUnsafe() else { return nil }
      return String(cString: value)
    }
    set { self.pointee.set_app_id(newValue) }
  }

  public var databaseURL: String? {
    get {
      guard let value = self.pointee.__database_urlUnsafe() else { return nil }
      return String(cString: value)
    }
    set { self.pointee.set_database_url(newValue) }
  }

  @available(*, unavailable)
  public var deepLinkURLScheme: String? { nil }

  public var storageBucket: String? {
    get {
      guard let value = self.pointee.__storage_bucketUnsafe() else {
        return nil
      }
      return String(cString: value)
    }
    set { self.pointee.set_storage_bucket(newValue) }
  }

  @available(*, unavailable)
  public var appGroupId: String? { nil }
}

extension FirebaseOptions {
  /// The format of a specified config file
  public enum ConfigFormat {
    /// Specifies that the file contents should be treated as a json string.
    case json
  }

  /// An added initializer which will allow loading of a config from a specified file.
  /// - Parameters:
  ///   - path: The path where the config file can be found.
  ///   - format: A format which describes how the content of the file should be treated.
  public init?(_contentsOfFile path: URL, format: ConfigFormat) {
    guard let data = try? Data(contentsOf: path, options: .alwaysMapped) else { return nil }
    switch format {
      case .json:
        let config = String(data: data, encoding: .utf8)
        guard let options = firebase.AppOptions.LoadFromJsonConfig(config, nil) else {
          return nil
        }
        self = options
    }
  }
}
