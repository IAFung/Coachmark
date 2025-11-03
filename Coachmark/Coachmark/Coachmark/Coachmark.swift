//
//  Coachmark.swift
//  XUI
//
//  Created by xueqooy on 2023/8/3.
//

import UIKit

public class Coachmark {
    public let rect: CGRect
    public let cutoutCornerStyle: CornerStyle
    public let contentView: CoachmarkGenericContentView

    private var cutoutCornerRadius: CGFloat {
        switch cutoutCornerStyle {
        case .capsule:
            return rect.height / 2
        case let .fixed(value):
            return value
        }
    }

    public init(rect: CGRect, cutoutCornerStyle: CornerStyle, contentView: CoachmarkGenericContentView) {
        self.rect = rect
        self.cutoutCornerStyle = cutoutCornerStyle
        self.contentView = contentView
    }
    
    func maskPath() -> UIBezierPath {
        let cutoutPath = UIBezierPath(roundedRect: rect, cornerRadius: cutoutCornerRadius)
        cutoutPath.usesEvenOddFillRule = true        
        return cutoutPath
    }

    func maskPath(for boundingRect: CGRect) -> CGPath {
        let cutoutPath = UIBezierPath(roundedRect: rect, cornerRadius: cutoutCornerRadius)
        cutoutPath.usesEvenOddFillRule = true

        let path = UIBezierPath(rect: boundingRect)
        path.append(cutoutPath)

        return path.cgPath
    }
}
public enum CornerStyle: Equatable {
    case fixed(CGFloat), capsule
}
