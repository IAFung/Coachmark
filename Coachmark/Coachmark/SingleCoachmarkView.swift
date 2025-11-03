//
//  SingleCoachmarkView.swift
//  Coachmark
//
//  Created by vodka on 2025/11/3.
//

import UIKit
import EasyPeasy
class SingleCoachmarkView: CoachmarkGenericContentView {
    let label = UILabel()
    override func commonInit() {
//        label.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        addSubview(label)
        label.text = "SingleCoachmarkView"
        label.backgroundColor = .red
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        label.addGestureRecognizer(tap)
    }
    override func layout() {
//        label.frame = CGRect(x: dummyView.frame.minX, y: dummyView.frame.maxY + 40, width: 400, height: 30)
        label.easy.layout(Top().to(dummyView), Left().to(dummyView, .left))
    }
    @objc func tapped() {
        controller.next()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

class SecondCoachmarkView: CoachmarkGenericContentView {
    let label = UILabel()
    
    let nextLabel = UILabel()
    override var insetsList: [UIEdgeInsets] {
        [.zero, UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 15)]
    }
    override var cornerStyleList: [CornerStyle] {
        [.capsule, .fixed(20)]
    }
    override func commonInit() {
        addSubview(label)
        addSubview(nextLabel)
        label.backgroundColor = .cyan
        label.isUserInteractionEnabled = true
        nextLabel.backgroundColor = .yellow
        label.text = "SecondCoachmarkView--button"
        nextLabel.text = "SecondCoachmarkView---container"
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        label.addGestureRecognizer(tap)
    }
    override func layout() {
       let secondDummy = dummyViews[1]
        label.easy.layout(Bottom(10).to(dummyView), Left().to(dummyView, .left))
        nextLabel.easy.layout(Top(10).to(secondDummy), Right().to(secondDummy, .right))

    }
    @objc func tapped() {
        controller.next()
    }
}
