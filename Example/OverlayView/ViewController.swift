//
//  ViewController.swift
//  OverlayView
//
//  Created by Duc iOS on 06/30/2021.
//  Copyright (c) 2021 Duc iOS. All rights reserved.
//

import UIKit
import OverlayView

class ViewController: UIViewController {
    
    let btnMiddle = UIButton(type: .system)
    let btnTop = UIButton(type: .system)
    let btnBottom = UIButton(type: .system)
    let btnView = UIButton(type: .system)
    let segmentX = UISegmentedControl()
    let segmentY = UISegmentedControl()
    let txfX = UITextField()
    let txfY = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnMiddle.setTitle("Middle", for: [])
        btnMiddle.addTarget(self, action: #selector(showMiddle), for: .touchUpInside)
        
        btnTop.setTitle("Top", for: [])
        btnTop.addTarget(self, action: #selector(showTop), for: .touchUpInside)
        
        btnBottom.setTitle("Bottom", for: [])
        btnBottom.addTarget(self, action: #selector(showBottom), for: .touchUpInside)
        
        btnView.setTitle("View", for: [])
        btnView.addTarget(self, action: #selector(showView), for: .touchUpInside)
        
        segmentX.insertSegment(withTitle: "Left", at: 0, animated: false)
        segmentX.insertSegment(withTitle: "Center", at: 1, animated: false)
        segmentX.insertSegment(withTitle: "Right", at: 2, animated: false)
        segmentX.selectedSegmentIndex = 0
        segmentX.addTarget(self, action: #selector(xValueChanged), for: .valueChanged)
        
        segmentY.insertSegment(withTitle: "Up", at: 0, animated: false)
        segmentY.insertSegment(withTitle: "Down", at: 1, animated: false)
        segmentY.selectedSegmentIndex = 0
        segmentY.addTarget(self, action: #selector(xValueChanged), for: .valueChanged)
        
        [txfX, txfY].forEach {
            $0.borderStyle = .line
            $0.keyboardType = .numberPad
            $0.textAlignment = .center
        }
        txfX.placeholder = "X"
        txfY.placeholder = "Y"
        
        let row = UIStackView(arrangedSubviews: [txfX, txfY])
        row.spacing = 8
        
        let column = UIStackView(arrangedSubviews: [btnMiddle, btnTop, btnBottom, btnView, segmentX, segmentY, row])
        column.alignment = .center
        column.axis = .vertical
        column.spacing = 8
        view.subviews(column)
        column.centerInContainer()
    }
    
    @objc func showMiddle(_ sender: UIButton) {
        let popup = UIView()
        popup.size(300)
        popup.backgroundColor = .orange
        popup.ov.show(position: .middle, dismissOnTap: true, dismissOnPan: .view())
    }
    
    @objc func showTop(_ sender: UIButton) {
        let popup = UIView()
        popup.height(300)
        popup.backgroundColor = .orange
        popup.ov.show(position: .top, dismissOnTap: true, dismissOnPan: .view())
    }
    
    @objc func showBottom(_ sender: UIButton) {
        let popup = UIView()
        popup.height(300)
        popup.backgroundColor = .orange
        popup.ov.show(position: .bottom, dismissOnTap: true, dismissOnPan: .view())
    }
    
    @objc func showView(_ sender: UIButton) {
        let popup = UIView()
        popup.size(300)
        popup.backgroundColor = .orange
        let directionX: OverlayView.DirectionX
        switch segmentX.selectedSegmentIndex {
        case 0: directionX = .left
        case 2: directionX = .right
        default: directionX = .center
        }
        let directionY: OverlayView.DirectionY
        switch segmentY.selectedSegmentIndex {
        case 0: directionY = .up
        default: directionY = .down
        }
        var point: CGPoint?
        if let x = Double(txfX.text!), let y = Double(txfY.text!) {
            point = CGPoint(x: CGFloat(x), y: CGFloat(y))
        }
        popup.ov.show(position: .view(sender, point, directionX: directionX, directionY: directionY), dismissOnTap: true, dismissOnPan: .view())
    }
    
    @objc func xValueChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
    
    @objc func yValueChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }

}

