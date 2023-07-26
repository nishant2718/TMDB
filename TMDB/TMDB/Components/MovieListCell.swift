//
//  MovieListCell.swift
//  TMDB
//
//  Created by Nishant Patel on 7/25/23.
//

import UIKit

class MovieListCell: UICollectionViewListCell {
    
    // MARK: - UI
    
    private struct UX {
        static let padding: CGFloat = 12
        static let elementSpacing: CGFloat = 40
        static let cornerRadius: CGFloat = 8
        static let minimumTextScaleFactor: CGFloat = 0.9
        static let numberOfLines: Int = 2
        static let titleFontSize: CGFloat = 20
        static let titleLabelHeight: CGFloat = 50
        static let posterImageWidth: CGFloat = 80
        static let posterImageHeight: CGFloat = 100
    }
    
    // Probably need a date formatter utility, or it can be done in the VC and then given to this cell
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = false
        imageView.layer.cornerRadius = UX.cornerRadius
        imageView.clipsToBounds = true
        imageView.backgroundColor = .tertiarySystemFill
        imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = UX.minimumTextScaleFactor
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = UX.numberOfLines
        label.font = UIFont.systemFont(ofSize: UX.titleFontSize, weight: .bold)
        
        return label
    }()
    
    lazy var movieYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = UX.minimumTextScaleFactor
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private helpers
    
    private func configure() {
        contentView.addSubviews([posterImageView, movieTitleLabel, movieYearLabel])
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UX.padding),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UX.elementSpacing),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UX.padding),
            posterImageView.widthAnchor.constraint(equalToConstant: UX.posterImageWidth),
            posterImageView.heightAnchor.constraint(equalToConstant: UX.posterImageHeight),
            
            movieTitleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            movieTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: UX.elementSpacing),
            movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UX.padding),
            movieTitleLabel.heightAnchor.constraint(equalToConstant: UX.titleLabelHeight),
            
            movieYearLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor),
            movieYearLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: UX.elementSpacing),
            movieYearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UX.padding)
        ])
    }
}
