//
//  ReusableLabel.swift
//  TMDB
//
//  Created by Nishant Patel on 7/26/23.
//

import UIKit

class ReusableLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    init(fontSize: CGFloat,
         isBold: Bool,
         numberOfLines: Int) {
        super.init(frame: .zero)
        
        if isBold {
            font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        } else {
            font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        }
        
        self.numberOfLines = numberOfLines
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .label
        textAlignment = .left
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.85
        lineBreakMode = .byTruncatingTail
    }
}
