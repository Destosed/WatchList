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
    
    var mediaType: MediaType? {
        get {
            switch mediaTypeLabel.text {
            case MediaType.movie.rawValue:
                return .movie
                
            case MediaType.serial.rawValue:
                return .serial
                
            case MediaType.book.rawValue:
                return .book
                
            case MediaType.anime.rawValue:
                return .anime
            
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
