// SPDX-License-Identifier: BSD-3-Clause

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftWin32

private final class FireBaseLogLevelPickerHandler {
  private let levels = ["Default", "Verbose", "Debug", "Info", "Warning", "Error", "Assert"]
}

extension FireBaseLogLevelPickerHandler: PickerViewDataSource {
  public func numberOfComponents(in pickerView: PickerView) -> Int {
    1
  }

  public func pickerView(_ pickerView: PickerView,
                         numberOfRowsInComponent component: Int) -> Int {
    self.levels.count
  }
}

extension FireBaseLogLevelPickerHandler: PickerViewDelegate {
  public func pickerView(_ pickerView: PickerView, titleForRow row: Int,
                         forComponent component: Int) -> String? {
    self.levels[row]
  }

  public func pickerView(_ pickerView: PickerView, didSelectRow row: Int,
                         inComponent component: Int) {
    guard row > 0 else { return }
    FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel(rawValue: CInt(row - 1)))
  }
}

// MARK: - FireBaseUIViewController

extension Rect {
  var maxY: Double {
    origin.y + size.height
  }

  var minY: Double {
    origin.y
  }

  var minX: Double {
    origin.x
  }

  var maxX: Double {
    origin.x + size.width
  }
}

internal final class FireBaseUIViewController: ViewController {
  fileprivate let firebaseLogHandler = FireBaseLogLevelPickerHandler()

  var cboLogLevel = PickerView(frame: Rect(x: 136, y: 8, width: 256, height: 24))
  var txtEmail = TextField(frame: Rect(x: 136, y: 46, width: 512, height: 24))
  var txtPassword = TextField(frame: Rect(x: 136, y: 78, width: 512, height: 24))
  var btnSignIn = Button(frame: Rect(x: 8, y: 116, width: 120, height: 32),
                         title: "Sign In")
  var btnToken = Button(frame: Rect(x: 8, y: 180, width: 120, height: 32),
                        title: "Get Token")
  var chkRefresh = Switch(frame: Rect(x: 8, y: 212, width: 648, height: 32),
                          title: "Force Token Refresh")
  var txtToken: TextView = TextView(frame: Rect(x: 8, y: 244, width: 640, height: 48))

  var btnCreate = Button(frame: Rect(x: 8, y: 324, width: 120, height: 32),
                         title: "Create User")
  var btnVerify = Button(frame: Rect(x: 132, y: 324, width: 120, height: 32),
                         title: "Verify Email")
  var btnReset = Button(frame: Rect(x: 256, y: 324, width: 156, height: 32),
                        title: "Reset Password")

  lazy var fetchUserDocumentButton: Button = {
    return Button(
      frame: .init(x: btnReset.frame.maxX, y: btnReset.frame.minY, width: 100, height: 32),
      title: "Get User"
    )
  }()

  lazy var userDetailsLabel = {
    Label(frame: .init(x: btnCreate.frame.minX, y: btnReset.frame.maxY, width: view.frame.width - 16, height: 400))
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "FireBase UI"
    configureView()

    if let user = Auth.auth().currentUser {
      txtEmail.text = user.email
      try? Auth.auth().signOut()
    }
  }

  private func configureView() {
    let lblLogLevel = Label(frame: Rect(x: 8, y: 8, width: 128, height: 24),
                            title: "Log Level:")
    self.view?.addSubview(lblLogLevel)

    cboLogLevel.dataSource = firebaseLogHandler
    cboLogLevel.delegate = firebaseLogHandler
    self.view?.addSubview(cboLogLevel)
    cboLogLevel.reloadAllComponents()
    cboLogLevel.selectRow(0, inComponent: 0, animated: false)

    let lblEmail = Label(frame: Rect(x: 8, y: 46, width: 128, height: 20),
                         title: "Email Address:")
    self.view?.addSubview(lblEmail)
    self.view?.addSubview(txtEmail)

    let lblPassword = Label(frame: Rect(x: 8, y: 78, width: 128, height: 20),
                            title: "Password:")
    self.view?.addSubview(lblPassword)

    txtPassword.isSecureTextEntry = true
    self.view?.addSubview(txtPassword)

    btnSignIn.addTarget(self, action: FireBaseUIViewController.signIn,
                        for: .primaryActionTriggered)
    self.view?.addSubview(btnSignIn)

    btnToken.addTarget(self, action: FireBaseUIViewController.getToken,
                        for: .primaryActionTriggered)
    self.view?.addSubview(btnToken)

    self.view?.addSubview(chkRefresh)

    txtToken.editable = false
    txtToken.font = .systemFont(ofSize: 9)
    self.view?.addSubview(txtToken)

    btnCreate.addTarget(self, action: FireBaseUIViewController.createUser,
                        for: .primaryActionTriggered)
    self.view?.addSubview(btnCreate)

    btnVerify.addTarget(self, action: FireBaseUIViewController.verifyEmail,
                        for: .primaryActionTriggered)
    self.view?.addSubview(btnVerify)

    btnReset.addTarget(self, action: FireBaseUIViewController.resetPassword,
                       for: .primaryActionTriggered)
    self.view?.addSubview(btnReset)

    fetchUserDocumentButton.addTarget(
      self,
      action: FireBaseUIViewController.fetchUserDocument,
      for: .primaryActionTriggered
    )

    userDetailsLabel.text = "No User Data Fetched"

    view?.addSubview(fetchUserDocumentButton)
    view?.addSubview(userDetailsLabel)
  }

  private func signIn() {
    guard let email = txtEmail.text, let password = txtPassword.text else {
        print("email and password are required")
        return
    }

    Task {
      do {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
      } catch {
        print("Error signing in: \(error.localizedDescription)")
      }
    }
  }

  private func createUser() {
    guard let email = txtEmail.text, let password = txtPassword.text else {
      print("email and password are required")
      return
    }

    Task {
      do {
        _ = try await Auth.auth().createUser(withEmail: email, password: password)
      } catch {
        print("Error signing in: \(error.localizedDescription)")
      }
    }
  }

  private func getToken() {
    Task {
      guard var user = Auth.auth().currentUser else {
        print("user not logged in")
        return
      }

      if chkRefresh.isOn {
        do {
          let result = try await user.getIDTokenResult(forcingRefresh: true)
          txtToken.text = result.token
        } catch {
          print("Error refreshing token: \(error.localizedDescription)")
        }
      } else {
        do {
          txtToken.text = try await user.getIDToken()
        } catch {
          print("Error refreshing token: \(error.localizedDescription)")
        }
      }
    }
  }

  private func verifyEmail() {
    Task {
      guard var user = Auth.auth().currentUser else {
        print("user not logged in")
        return
      }

      try await user.sendEmailVerification()
    }
  }

  private func resetPassword() {
    guard let email = txtEmail.text else {
      print("email is required")
      return
    }

    Task {
      do {
        _ = try await Auth.auth().sendPasswordReset(withEmail: email)
      } catch {
        print("Error sending password reset: \(error.localizedDescription)")
      }
    }
  }

  private func fetchUserDocument() {
    guard let user = Auth.auth().currentUser else {
      print("No current user, can't fetch document...")
      return
    }

    Task {
      do {
        let firestore = Firestore.firestore()
        let document = firestore
          .collection("users")
          .document(user.uid)
        let snapshot = try await document.get()
        await MainActor.run { [weak self] in
          guard let self else { return }
          userDetailsLabel.text = snapshot.debugDescription
        }
      } catch {
        print("Error fetching snapshot: \(error)")
      }
    }
  }
}
