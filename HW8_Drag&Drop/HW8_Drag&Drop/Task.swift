//
//  Task.swift
//  HW8_Drag&Drop
//
//  Created by Roman Cheremin on 25/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

/// Task model representation
class Task {
    let title: String
    let desc: String
    
    init(title: String, desc: String) {
        self.title = title
        self.desc = desc
    }
}
