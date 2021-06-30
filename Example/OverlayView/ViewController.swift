//
//  ViewController.swift
//  OverlayView
//
//  Created by Duc iOS on 06/30/2021.
//  Copyright (c) 2021 Duc iOS. All rights reserved.
//

import UIKit
import Stevia
import OverlayView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnMiddle = UIButton(type: .system)
        btnMiddle.setTitle("Show at middle", for: [])
        btnMiddle.addTarget(self, action: #selector(showMiddle), for: .touchUpInside)
        
        let btnBottom = UIButton(type: .system)
        btnBottom.setTitle("Show from bottom", for: [])
        btnBottom.addTarget(self, action: #selector(showBottom), for: .touchUpInside)
        
        let btnBottomCenter = UIButton(type: .system)
        btnBottomCenter.setTitle("Show from bottom center", for: [])
        btnBottomCenter.addTarget(self, action: #selector(showBottomCenter), for: .touchUpInside)
        
        let vStack = UIStackView(arrangedSubviews: [btnMiddle, btnBottom, btnBottomCenter])
        vStack.axis = .vertical
        view.sv(vStack)
        vStack.centerInContainer()
    }
    
    @objc func showMiddle() {
        let popup = UIView()
        popup.size(300)
        popup.backgroundColor = .orange
        popup.ov.show(position: .middle,  dismissOnTap: true)
    }
    
    @objc func showBottom() {
        let popup = UIView()
        popup.height(600)
        popup.backgroundColor = .orange
        popup.ov.show(position: .bottom,  dismissOnTap: true)
    }
    
    @objc func showBottomCenter() {
        let popup = UIView()
        popup.height(600).width(300)
        popup.backgroundColor = .orange
        popup.ov.show(position: .bottom,  dismissOnTap: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

