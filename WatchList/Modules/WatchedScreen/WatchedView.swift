//
//  WatchedView.swift
//  WatchList
//
//  Created by Никита Лужбин on 20.05.2020.
//  Copyright © 2020 Никита. All rights reserved.
//

import Foundation
import UIKit

class WatchedView: UIViewController, WatchedViewProtocol {
    
    // MARK: - Nested Types
    
    enum Constants {
        
        // MARK: - Type Properties
        
        static let mediaTypeCell = "MediaTypeCell"
        static let mediaItemCell = "MediaItemCell"
    }
    
    // MARK: - Instance Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Instance Methods
    
    private func presentMediaTypePicker() {
        
    }
    
    private func presentMoreOptionsAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            let searchStoryboard = UIStoryboard(name: "Search", bundle: nil)
            guard let searchController = searchStoryboard.instantiateInitialViewController() else {
                return
            }
            
            self?.present(searchController, animated: true, completion: nil)
        })
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: -
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibMediaTypeCell = UINib(nibName: Constants.mediaTypeCell, bundle: nil)
        self.tableView.register(nibMediaTypeCell, forCellReuseIdentifier: Constants.mediaTypeCell)
        
        let nibMediaItemCell = UINib(nibName: Constants.mediaItemCell, bundle: nil)
        self.tableView.register(nibMediaItemCell, forCellReuseIdentifier: Constants.mediaItemCell)
        
        self.tableView.separatorStyle = .none
        
    }
    
    private func configureMediaTypeCell(cell: MediaTypeCell) {
        cell.selectionStyle = .none
    }
    
    private func configureMediaItemCell(cell: MediaItemCell) {
        cell.selectionStyle = .none
    }
    
    // MARK: -
    
    @IBAction private func onMoreButtonTouchUpInside(_ sender: UIBarButtonItem) {
        self.presentMoreOptionsAlert()
    }
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
    }
}

// MARK: - UITableViewDataSource

extension WatchedView: UITableViewDataSource {
    
    // MARK: - Instance Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mediaTypeCell) as! MediaTypeCell
            self.configureMediaTypeCell(cell: cell)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mediaItemCell) as! MediaItemCell
            self.configureMediaItemCell(cell: cell)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension WatchedView: UITableViewDelegate {
    
    // MARK: - Instance Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70.0
            
        default:
            return 170.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.presentMediaTypePicker()
            
        default:
            return
        }
    }
}
