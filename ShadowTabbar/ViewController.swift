//
//  ViewController.swift
//  ShadowTabbar
//
//  Created by Kishan Barmawala on 12/10/20.
//  Copyright © 2020 Kishan Barmawala. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var shadowTabbar: ShadowTabbar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        shadowTabbar.preselectTab = 4
        shadowTabbar.delegate = self
    }

}

extension ViewController: ShadowDelegate {
    
    func shadowTabbar(didSelectAt index: Int) {
        print("Select At :=>",index)
    }
    
}
