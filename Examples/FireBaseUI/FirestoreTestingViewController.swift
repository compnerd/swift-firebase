// SPDX-License-Identifier: BSD-3-Clause

import FirebaseFirestore
import SwiftWin32

internal final class FirestoreTestingViewController: ViewController {
  private let textField: TextField = .init(frame: .zero)
  private let startButton: Button = .init(frame: .zero, title: "Start")
  private let stopButton: Button = .init(frame: .zero, title: "Stop")
  private let fetchButton: Button = .init(frame: .zero, title: "Fetch")
  private let dataLabel: Label = .init(frame: .zero)

  private var subscription: ListenerRegistration? {
    didSet {
      fetchButton.isUserInteractionEnabled = subscription == nil
      startButton.isUserInteractionEnabled = subscription == nil
      stopButton.isUserInteractionEnabled = subscription != nil
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view?.addSubview(textField)
    view?.addSubview(startButton)
    view?.addSubview(stopButton)
    view?.addSubview(fetchButton)
    view?.addSubview(dataLabel)

    dataLabel.text = "No Data..."

    title = "Firestore Testing"

    fetchButton.addTarget(self,
                          action: FirestoreTestingViewController.fetchFromInput,
                          for: .primaryActionTriggered)

    startButton.addTarget(self,
                          action: FirestoreTestingViewController.startSubscriptionFromInput,
                          for: .primaryActionTriggered)

    stopButton.addTarget(self,
                         action: FirestoreTestingViewController.stopSubscription,
                         for: .primaryActionTriggered)

    layoutView()
  }

  private func layoutView() {
    let padding = 8.0
    textField.frame = .init(x: padding, y: padding, width: view!.bounds.width, height: 30)

    let usableWidth = view!.bounds.width
    let buttonWidth = usableWidth / 3
    let buttonHeight = 30.0
    let buttonY = textField.frame.maxY + padding

    fetchButton.frame = .init(x: padding, y: buttonY, width: buttonWidth, height: buttonHeight)
    startButton.frame = .init(x: fetchButton.frame.maxX, y: buttonY, width: buttonWidth, height: buttonHeight)
    stopButton.frame = .init(x: startButton.frame.maxX, y: buttonY, width: buttonWidth, height: buttonHeight)

    let dataLabelY = stopButton.frame.maxY + padding
    dataLabel.frame = .init(x: padding, y: dataLabelY, width: usableWidth, height: view!.bounds.maxY - stopButton.frame.maxY)
  }

  func fetch(path: String) {
    Task {
      await buttonsEnabled(false)
      let document = Firestore.firestore().document(path)
      do {
        let snapshot = try await document.getDocument()
        await displayData(data: snapshot.debugDescription)
      } catch {
        await displayError(error: error)
      }
      await buttonsEnabled(true)
    }
  }

  func startSubscription(to path: String) {
    if subscription != nil {
      stopSubscription()
    }

    subscription = Firestore.firestore().document(path).addSnapshotListener { [weak self] snapshot, error  in
      Task { [weak self] in
        let data = snapshot?.data(with: .none)
        await self?.displayData(data: String(describing: dump(data)))
      }
    }
  }

  func stopSubscription() {
    guard let subscription else { return }

    subscription.remove()
    self.subscription = nil
  }

  private func fetchFromInput() {
    guard let path = textField.text else { return }
    fetch(path: path)
  }

  private func startSubscriptionFromInput() {
    guard let path = textField.text else { return }
    startSubscription(to: path)
  }

  @MainActor
  private func buttonsEnabled(_ enabled: Bool) {
    fetchButton.isUserInteractionEnabled = enabled
    startButton.isUserInteractionEnabled = enabled
    stopButton.isUserInteractionEnabled = enabled
    textField.isUserInteractionEnabled = enabled
  }

  @MainActor
  private func displayError(error: Error) {
    dataLabel.text = "\(error)"
  }

  @MainActor
  private func displayData(data: String) {
    dataLabel.text = data
  }
}
