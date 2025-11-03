//
//  CoachmarkController.swift
//  XUI
//
//  Created by xueqooy on 2023/8/3.
//

import Combine
import UIKit

public protocol CoachmarkControllerDataSource: AnyObject {
    func coachmarkController(_ controller: CoachmarkController, requestCoachmarkAt index: Int, completionHandler: @escaping (Coachmark?, [Coachmark]?) -> Void)
}

public class CoachmarkController {
    private struct State: Equatable {
        let id: UUID
        let index: Int

        init(id: UUID = .init(), index: Int = 0) {
            self.id = id
            self.index = index
        }

        func next() -> State {
            .init(id: id, index: index + 1)
        }
    }

    public weak var dataSource: CoachmarkControllerDataSource?

    var window: CoachmarkWindow?

    var viewController: CoachmarkViewController?

    private var state: State?

    private var animationId: UUID?

    private lazy var windowLayoutPropertyObserver = ViewLayoutPropertyObserver()

    private var windowLayoutPropertyChangeSubscription: AnyCancellable?

    public init() {}

    @MainActor public func start() {
        state = State()

        window = createWindow()
        viewController = createViewController()

        window!.rootViewController = viewController!
        next()
    }

    @MainActor public func stop() {
        let previousWindow = window
        let previousViewController = viewController

        viewController = nil
        window = nil
        state = nil

        guard let previousWindow = previousWindow, let previousViewController = previousViewController else {
            return
        }

        previousViewController.coachmarks = nil
        previousViewController.animateOut {
            previousWindow.rootViewController = nil
            previousWindow.isHidden = true
        }
    }

    @MainActor public func next() {
        guard let state = state else {
            stop()
            return
        }

        self.state = state.next()

        requestCoachmark(for: state)
    }
    
    @MainActor private func requestCoachmark(for state: State) {
        guard let dataSource = dataSource else {
            return
        }

        var isCompleted = false
        dataSource.coachmarkController(self, requestCoachmarkAt: state.index) { coachmark, coachmarks in
            _coachmark(coachmark: coachmark, coachmarks: coachmarks)
        }
        
        func _coachmark(coachmark: Coachmark?, coachmarks: [Coachmark]?) {
            isCompleted = true
            guard let viewController = self.viewController,
                  let currentState = self.state else {
                return
            }
            guard state.next() == currentState else {
                return
            }
            
            var marks = [Coachmark]()
            if let coachmark = coachmark  { //有单个
                marks = [coachmark]
            } else if let coachmarks = coachmarks { //有多个
                 marks = coachmarks
            } else { //都没有
                self.stop()
                return
            }
            self.animationIn()
            if let contentView = marks.first?.contentView {
                contentView.coachmarkRect(marks.map { $0.rect })
            }
            viewController.coachmarks = marks
        }

        if !isCompleted {
            animationOut()
        }
    }

    // MARK: - Creation

    private func createViewController() -> CoachmarkViewController {
        .init()
    }

    @MainActor private func createWindow() -> CoachmarkWindow {
        guard let windowScene = UIApplication.shared.activeScene else {
            let bounds = UIApplication.shared.keyWindows.first?.bounds ?? UIScreen.main.bounds
            return CoachmarkWindow(frame: bounds)
        }

        let keywindow = windowScene.windows.first { $0.isKeyWindow }
        let window = CoachmarkWindow(windowScene: windowScene)
        window.frame = keywindow?.bounds ?? UIScreen.main.bounds
//
//        // Requesting coachmark again when the window frame changes（e.g. device rotation changed）
//        windowLayoutPropertyObserver.addToView(window)
//        windowLayoutPropertyChangeSubscription = windowLayoutPropertyObserver.propertyDidChangePublisher
//            .dropFirst()
//            .sink { [weak self] _ in
//                guard let self, let state = self.state else {
//                    return
//                }
//                self.state = State(index: max(0, state.index - 1))
//                self.next()
//            }

        return window
    }

    // MARK: - Animation

    @MainActor private func animationIn() {
        animationId = UUID()

        viewController?.animateIn(forced: window?.isHidden ?? false)
        window?.isHidden = false
    }

    @MainActor private func animationOut() {
        let id = UUID()
        animationId = id

        viewController?.coachmarks = nil
        viewController?.animateOut { [weak self] in
            guard let self = self, id == animationId else {
                return
            }

            window?.isHidden = true
        }
    }
}
extension UIApplication {
    var activeScene: UIWindowScene? {
        connectedScenes.filter { $0.activationState == .foregroundActive }.first as? UIWindowScene
    }

    var keyWindows: [UIWindow] {
        if #available(iOS 15, *) {
            return UIApplication
                .shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        } else {
            return UIApplication
                .shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .filter { $0.isKeyWindow }
        }
    }
}
