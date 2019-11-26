//
//  VCExtentions.swift
//  HW8_Drag&Drop
//
//  Created by Roman Cheremin on 26/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = data.items[indexPath.section][indexPath.row].title
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension ViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
    {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            return
        }
        
        switch coordinator.proposal.operation
        {
        case .move:
//            collectionView.cellForItem(at: destinationIndexPath)?.prepareForReuse()
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            break
        default:
            return
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as? TaskCell {
            cell.setupCell(with: data.items[indexPath.section][indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewMode {
        case .view:
            return
        case .select:
            let cell = collectionView.cellForItem(at: indexPath)
            let makevisible = cell?.contentView.viewWithTag(21)
            makevisible?.alpha = 1
            dictionaryWithSelectedCells[indexPath] = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if viewMode == .select {
            let mycell = collectionView.cellForItem(at: indexPath)
            let remove = mycell?.contentView.viewWithTag(21)
            remove?.alpha = 0
            dictionaryWithSelectedCells[indexPath] = false
        }
    }
}
