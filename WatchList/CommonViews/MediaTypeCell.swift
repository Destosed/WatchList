//
//  MediaTypeCell.swift
//  WatchList
//
//  Created by Никита Лужбин on 20.05.2020.
//  Copyright © 2020 Никита. All rights reserved.
//

import UIKit

class MediaTypeCell: UITableViewCell {
    
    // MARK: - Instance Properties

    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var mediaTypeLabel: UILabel!
    
    // MARK: -
    
    var category: Category? {
        get {
            switch mediaTypeLabel.text {
            case Category.film.rawValue:
                return .film
                
            case Category.series.rawValue:
                return .series
                
            case Category.anime.rawValue:
                return .anime
                
            case Category.all.rawValue:
                return .all
                
            default:
                return nil
            }
        }
        
        set {
            self.mediaTypeLabel.text = newValue?.rawValue
        }
    }
    
    // MARK: - UITableViewCell
    
    override func awakeFromNib() {
        self.mainView.layer.shadowColor = UIColor.black.cgColor
        self.mainView.layer.shadowOpacity = 0.5
        self.mainView.layer.shadowOffset = .zero
        self.mainView.layer.shadowRadius = 3
        
        self.mainView.layer.cornerRadius = 10.0
    }
}
