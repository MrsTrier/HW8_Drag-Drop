//
//  CellsSelection.swift
//  HW8_Drag&Drop
//
//  Created by Roman Cheremin on 26/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import Foundation
class CellsSelector {
    var collectionView: UICollectionView
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    enum Mode {
        case view
        case select
    }
    
    var viewMode: Mode = .view {
        didSet {
            switch viewMode {
            case .view:
                collectionView.allowsMultipleSelection = false
            case .select:
                collectionView.allowsMultipleSelection = true
            }
        }
    }
    
    var dictionaryWithSelectedCells : [IndexPath : Bool] = [:]

    
}
