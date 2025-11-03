//
//  CoachmarkViewController.swift
//  XUI
//
//  Created by xueqooy on 2023/8/3.
//

import UIKit

class CoachmarkViewController: UIViewController {
    private enum Constants {
        static let pathAnimtionDuration = 0.25
        static let animationInOutDuration = 0.15
    }

    var coachmarks: [Coachmark]? {
        didSet {
            containerView.removeFromSuperview()
            containerView.subviews.forEach { $0.removeFromSuperview() }
            guard let coachmarks = coachmarks else {
//                let previousMaskPath = maskLayer.path
                let maskPath = UIBezierPath().cgPath
                maskLayer.path = maskPath
//                maskLayer.animate(from: previousMaskPath, to: maskPath, keyPath: "path", duration: Constants.pathAnimtionDuration)
                return
            }

            transition(to: coachmarks)
        }
    }
    
    var containerView = UIView()

    private lazy var backgroundView = UIView()


    private lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillRule = .evenOdd
        return layer
    }()

    deinit {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    private func initialize() {
        maskLayer.path = UIBezierPath().cgPath
        backgroundView.layer.mask = maskLayer
        backgroundView.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func animateIn(forced: Bool) {
        guard backgroundView.layer.opacity != 1 || forced else {
            return
        }

        backgroundView.layer.opacity = 1
    }

    func animateOut(_ completion: @escaping () -> Void) {
        guard backgroundView.layer.opacity != 0 else {
            completion()
            return
        }

        backgroundView.layer.opacity = 0
        completion()
    }

    func transition(to coachmarks: [Coachmark]) {
        view.addSubview(containerView)
        //添加约束
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        let path = UIBezierPath(rect: view.bounds)
        let contentView = coachmarks.first?.contentView
        for coachmark in coachmarks {
            let maskPath = coachmark.maskPath()
            path.append(maskPath)
        }

//        if let previousMaskPath = maskLayer.path {
//            maskLayer.path = maskPath
//            maskLayer.animate(from: previousMaskPath, to: maskPath, keyPath: "path", duration: Constants.pathAnimtionDuration) { [weak self] _ in
//                guard let self = self, self.coachmark === coachmark else {
//                    return
//                }
//                containerView.addSubview(coachmark.contentView)
//                coachmark.contentView.easy.layout(Edges())
//            }
//        } else {
        maskLayer.path = path.cgPath
        if let contentView {
            containerView.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: view.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }
//        }
    }
}
