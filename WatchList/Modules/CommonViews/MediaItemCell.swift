//
//  MediaItemCell.swift
//  WatchList
//
//  Created by Никита Лужбин on 20.05.2020.
//  Copyright © 2020 Никита. All rights reserved.
//

import UIKit

class MediaItemCell: UITableViewCell {
    
    // MARK: - Instance Properties
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var ratingView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var noteLabel: UILabel!
    
    // MARK: -
    
    var title: String? {
        get {
            return self.titleLabel.text
        }
        
        set {
            self.titleLabel.text = newValue
        }
    }
    
    var subTitle: String? {
        get {
            return self.subtitleLabel.text
        }
        
        set {
            self.subtitleLabel.text = newValue
        }
    }
    
    var poster: UIImage? {
        get {
            self.posterImageView.image
        }
        
        set {
            self.posterImageView.image = newValue
        }
    }
    
    var imageViewTarget: UIImageView {
        get {
            return self.posterImageView
        }
        
        set {
            self.posterImageView = newValue
        }
    }
    
    var note: String? {
        get {
            return self.noteLabel.text
        }
        
        set {
            self.noteLabel.text = newValue
        }
    }
    
    var rating: Double? {
        get {
            if let ratingText = self.ratingLabel.text, let rating = Int(ratingText) {
                return Double(rating)
            }
            return nil
        }
        
        set {
            guard let newValue = newValue else {
                self.ratingView.isHidden = true
                return
            }
            
            self.ratingLabel.text = String(newValue)
            
            switch newValue {
            case 7...10:
                self.ratingLabel.backgroundColor = .green
            
            case 4...7:
                self.ratingLabel.backgroundColor = .yellow
                
            case 0...4:
                self.ratingLabel.backgroundColor = .red
                
            default:
                self.ratingView.isHidden = true
            }
        }
    }
    
    // MARK: - UITableVIewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainView.layer.shadowColor = UIColor.black.cgColor
        self.mainView.layer.shadowOpacity = 0.5
        self.mainView.layer.shadowOffset = .zero
        self.mainView.layer.shadowRadius = 3
        
        self.mainView.layer.cornerRadius = 10.0
        
        self.ratingView.layer.cornerRadius = 5.0
        self.ratingView.clipsToBounds = true
        
        self.posterImageView.clipsToBounds = true
        self.posterImageView.layer.cornerRadius = 10.0
        self.posterImageView.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMinXMaxYCorner ]
    }
}

