//
//  ViewController.swift
//  ShadowTabbar
//
//  Created by Kishan Barmawala on 12/10/20.
//  Copyright © 2020 Kishan Barmawala. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var shadowTabbar: ShadowTabbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shadowTabbar.delegate = self
        shadowTabbar.numberOfTabs = 5
        shadowTabbar.preselectTabIdx = 4
        shadowTabbar.tabbarImages = [UIImage(named: "home"),UIImage(named: "heart"),UIImage(named: "message"),UIImage(named: "notification"),UIImage(named: "search")]
    }

}

extension ViewController: ShadowDelegate {
    
    func shadowTabbar(didSelectAt index: Int) {
        label.text = "Selected tab index: \(index+1)"
    }
    
}
