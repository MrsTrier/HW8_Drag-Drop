//
//  ViewController.swift
//  HW8_Drag&Drop
//
//  Created by Roman Cheremin on 25/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TaskCreationViewProtocol, UICollectionViewDelegate {
    
    var data = DataSource()

    var dictionaryWithSelectedCells : [IndexPath : Bool] = [:]

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
    
    /// Calculate where navigation bar ends
    var topDistance : CGFloat{
        guard let navigationController = self.navigationController, navigationController.navigationBar.isTranslucent else {
            return 0
        }
        let barHeight = navigationController.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.isStatusBarHidden ? 0.0 : UIApplication.shared.statusBarFrame.height
        return barHeight + statusBarHeight
    }
    
    let collectionView: UICollectionView = {
        let layout = ISSCustomLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red:0.27, green:0.46, blue:0.58, alpha:1.0)
        collectionView.dragInteractionEnabled = true
        collectionView.register(TaskCell.self, forCellWithReuseIdentifier: "TaskCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation bar setup
        self.title = "JUST DOOO IT"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        collectionView.allowsMultipleSelection = false
        // columns' title creation
        let headerView = createHeader(point: topDistance)
        
        // collection view frame setup
        let collectionViewPoint = topDistance + headerView.frame.height
        collectionView.frame = CGRect(x: 0, y: collectionViewPoint, width: view.frame.width, height: view.frame.height - collectionViewPoint)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        
        view.addSubview(collectionView)
        view.addSubview(headerView)
    }
    
    func createHeader(point safeAreaPoint: CGFloat) -> UIStackView {
        let headerView = UIStackView(frame: CGRect(x: 0, y: safeAreaPoint, width: view.frame.width, height: 32))
        headerView.axis = .horizontal
        headerView.distribution = .fillEqually
        headerView.alignment = .center
        headerView.addBackground(color: UIColor(red:0.93, green:0.74, blue:0.42, alpha:1.0))
        
        let toDoLabel = UILabel()
        toDoLabel.textColor = UIColor(red:0.02, green:0.03, blue:0.18, alpha:1.0)
        toDoLabel.textAlignment = .center
        toDoLabel.text = "To Do"
        
        let inProgressLabel = UILabel()
        inProgressLabel.textColor = UIColor(red:0.02, green:0.03, blue:0.18, alpha:1.0)
        inProgressLabel.textAlignment = .center
        inProgressLabel.text = "In Progress"
        
        let inReviewLabel = UILabel()
        inReviewLabel.textColor = UIColor(red:0.02, green:0.03, blue:0.18, alpha:1.0)
        inReviewLabel.textAlignment = .center
        inReviewLabel.text = "In Review"
        
        let doneLabel = UILabel()
        doneLabel.textColor = UIColor(red:0.02, green:0.03, blue:0.18, alpha:1.0)
        doneLabel.textAlignment = .center
        doneLabel.text = "Done"
        
        headerView.addArrangedSubview(toDoLabel)
        headerView.addArrangedSubview(inProgressLabel)
        headerView.addArrangedSubview(inReviewLabel)
        headerView.addArrangedSubview(doneLabel)
        
        return headerView
    }
    
    
    @objc func deleteButtonTapped() {
        collectionView.dragInteractionEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
        var toDelete: [IndexPath] = []
        for (path, key) in dictionaryWithSelectedCells {
            if key {
                toDelete.append(path)
            }
        }
        for i in toDelete.sorted(by: { $0.item > $1.item } ) {
            data.items[i.section].remove(at: i.row)
        }
        for section in 0..<(data.items.count) {
            for cell in 0..<(data.items[section].count) {
                let mycell = collectionView.cellForItem(at: IndexPath(row: cell, section: section))
                let hide = mycell?.contentView.viewWithTag(21)
                hide?.alpha = 0
            }
        }
        collectionView.deleteItems(at: toDelete)
        dictionaryWithSelectedCells.removeAll()
        viewMode  = .view
    }
    
    @objc func selectButtonTapped() {
        collectionView.dragInteractionEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        collectionView.allowsMultipleSelection = true
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped)), UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))]
        viewMode = .select
    }
    
    @objc func cancelButtonTapped() {
        viewMode = .view
        collectionView.dragInteractionEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItems = nil
        for section in 0..<(data.items.count) {
            for cell in 0..<(data.items[section].count) {
                let mycell = collectionView.cellForItem(at: IndexPath(row: cell, section: section))
                let hide = mycell?.contentView.viewWithTag(21)
                hide?.alpha = 0
            }
        }
        dictionaryWithSelectedCells.removeAll()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
    }
    
    @objc func addButtonTapped() {
        let popUpView = TaskCreationView(frame: view.frame)
        
        popUpView.frame = view.frame
        popUpView.delegate = self
        popUpView.makeVisible()
        
        view.addSubview(popUpView)
        
        self.navigationItem.rightBarButtonItem = nil
    }
    
    /// Add new task to "To Do" column - TaskCreationViewProtocol implementation
    ///
    /// - Parameters:
    ///   - title: task title
    ///   - desc: task description
    func taskDidCreated(withTitle title: String, desc: String) {
        data.items[0].append(Task(title: title, desc: desc))
        collectionView.reloadData()
        let hide = collectionView.viewWithTag(21)
        hide?.alpha = 0
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    /// When view is removed without task creation we need to add bar button back
    func taskCreationDidCanceled() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            collectionView.performBatchUpdates({
                if sourceIndexPath.row == collectionView.numberOfItems(inSection: sourceIndexPath.section) - 1 {
                    return
                }
                if sourceIndexPath.section == destinationIndexPath.section {
                    return
                }
                if destinationIndexPath.row >= collectionView.numberOfItems(inSection: destinationIndexPath.section) {
                    return
                }
                let element = data.items[sourceIndexPath.section].remove(at: sourceIndexPath.row)
                data.items[destinationIndexPath.section].insert(element, at: destinationIndexPath.row)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
                let hide = collectionView.viewWithTag(21)
                hide?.alpha = 0
            })
            collectionView.reloadData()

            coordinator.drop(items.first!.dragItem, toItemAt: destinationIndexPath)

        }
    }
}
