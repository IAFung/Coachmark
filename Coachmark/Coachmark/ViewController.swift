//
//  ViewController.swift
//  Coachmark
//
//  Created by vodka on 2025/11/3.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    let coachmarkController = CoachmarkController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coachmarkController.dataSource = self
    }
    @IBOutlet weak var container: UIView!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        coachmarkController.start()
    }
}
extension ViewController: CoachmarkControllerDataSource {
    func coachmarkController(_ controller: CoachmarkController, requestCoachmarkAt index: Int, completionHandler: @escaping (Coachmark?, [Coachmark]?) -> Void) {
        
        switch index {
        case 1:
            let contentView = SingleCoachmarkView(controller: controller)
            let mark = contentView.coachmark(for: button)
            completionHandler(mark, nil)
        case 0:
            let contentView = SecondCoachmarkView(controller: controller)
            let marks = contentView.coachmarks(for: [button!, container!])
            completionHandler(nil, marks)
        default:
            completionHandler(nil, nil)
        }
    }
}
