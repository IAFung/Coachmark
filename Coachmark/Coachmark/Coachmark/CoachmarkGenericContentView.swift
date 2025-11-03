//
//  CoachmarkGenericContentView.swift
//  XUI
//
//  Created by xueqooy on 2023/8/5.
//

import UIKit

public class CoachmarkGenericContentView: UIView {
    var controller: CoachmarkController
    var cornerStyle: CornerStyle {
        .fixed(8)
    }
    var insets: UIEdgeInsets {
        .zero
    }
    var cornerStyleList: [CornerStyle] {
        []
    }
    var insetsList: [UIEdgeInsets] {
        []
    }
    public init(controller: CoachmarkController) {
        self.controller = controller
        super.init(frame: .zero)
        commonInit()
    }
    //dummyViews的顺序和传入的mask顺序一样
    public var dummyViews: [UIView] = []
    public var dummyView: UIView {
        dummyViews.first ?? UIView()
    }
    func coachmarkRect(_ rects: [CGRect]) {
        dummyViews = rects.map { UIView(frame: $0) }
        dummyViews.forEach { addSubview($0) }
        layout()
    }
    public func layout() {
        
    }
    
    public func commonInit() {}

    override public init(frame: CGRect) {
        fatalError("Use init(controller:) instead.")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CoachmarkGenericContentView {
    func coachmark(for viewOrBarItemOrNil: Any?) -> Coachmark {
        let rect: CGRect
        if let anchorView = viewOrBarItemOrNil as? UIView {
            rect = controller.coachmarkRect(for: anchorView, insets: insets)
        } else if let barButtonItem = viewOrBarItemOrNil as? UIBarButtonItem {
            rect = controller.coachmarkRect(for: barButtonItem, insets: insets)
        } else if let tabBarItem = viewOrBarItemOrNil as? UITabBarItem {
            rect = controller.coachmarkRect(for: tabBarItem, insets: insets)
        } else {
            rect = .zero
        }
        return Coachmark(rect: rect, cutoutCornerStyle: cornerStyle, contentView: self)
    }
    func coachmarks(for viewOrBarItemOrNil: [Any]?) -> [Coachmark] {
        var marks = [Coachmark]()
        for (index, view) in (viewOrBarItemOrNil ?? []).enumerated() {
            let rect: CGRect
            let insets = (insetsList.count > index) ? insetsList[index] : self.insets
            let cornerStyle = (cornerStyleList.count > index) ? cornerStyleList[index] : self.cornerStyle
            if let anchorView = view as? UIView {
                rect = controller.coachmarkRect(for: anchorView, insets: insets)
            } else if let barButtonItem = view as? UIBarButtonItem {
                rect = controller.coachmarkRect(for: barButtonItem, insets: insets)
            } else if let tabBarItem = view as? UITabBarItem {
                rect = controller.coachmarkRect(for: tabBarItem, insets: insets)
            } else {
                rect = .zero
            }
            let mark = Coachmark(rect: rect, cutoutCornerStyle: cornerStyle, contentView: self)
            marks.append(mark)
        }
        return marks
    }
}
