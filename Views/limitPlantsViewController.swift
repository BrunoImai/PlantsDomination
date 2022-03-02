//
//  limitPlantsViewController.swift
//  Plantinhas
//
//  Created by Bruno Imai on 02/03/22.
//

import UIKit

class limitPlantsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        _ = self.view
    }

    @IBAction func returnToFarm(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
