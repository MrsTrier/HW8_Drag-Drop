//
//  UIStackView.swift
//  HW8_Drag&Drop
//
//  Created by Roman Cheremin on 26/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

extension UIStackView {
    
    /// Set stack view background color
    ///
    /// - Parameter color: background color
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
