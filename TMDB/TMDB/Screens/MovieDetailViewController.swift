//
//  MovieDetailViewController.swift
//  TMDB
//
//  Created by Nishant Patel on 7/26/23.
//

import UIKit

class MovieDetailViewController: UIViewController {
    private struct UX {
        static let largeText: CGFloat = 20
        static let regularText: CGFloat = 16
        static let movieTitleLinesSpan: Int = 2
        static let minimumTextScaleFactor: CGFloat = 0.9
        static let imageCornerRadius: CGFloat = 12
        static let padding: CGFloat = 12
        static let extraPadding: CGFloat = 16
        static let posterWidth: CGFloat = 110
        static let posterHeight: CGFloat = 160
        static let largeLabelHeight: CGFloat = 40
        static let smallLabelHeight: CGFloat = 20
    }
    
    var viewModel: MovieDetailViewModel?
    
    lazy private var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isUserInteractionEnabled = true
        
        return scrollView
    }()
    
    lazy private var posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = false
        imageView.layer.cornerRadius = UX.imageCornerRadius
        imageView.clipsToBounds = true
        imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    lazy private var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = .tertiarySystemFill
        progressView.progressTintColor = .systemIndigo
        
        return progressView
    }()
    
    lazy private var topDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemFill
        
        return view
    }()
    
    lazy private var bottomDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemFill
        
        return view
    }()
    
    private let movieTitleLabel = ReusableLabel(fontSize: UX.largeText, isBold: true, numberOfLines: UX.movieTitleLinesSpan)
    private let movieDateLabel = ReusableLabel(fontSize: UX.regularText, isBold: false, numberOfLines: 0)
    private let viewerRatingLabel = ReusableLabel(fontSize: UX.regularText, isBold: false, numberOfLines: 0)
    private let viewerRatingScoreLabel = ReusableLabel(fontSize: UX.largeText, isBold: true, numberOfLines: 0)
    private let overviewLabel = ReusableLabel(fontSize: UX.largeText, isBold: true, numberOfLines: 0)
    private let overviewDetailsLabel = ReusableLabel(fontSize: UX.regularText, isBold: false, numberOfLines: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupLayout()
        configureElements()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel?.viewDidDisappear()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    // MARK: - Private helpers
    
    private func setupLayout() {
        view.addSubview(scrollView)
        
        scrollView.addSubviews([posterImage,
                                movieTitleLabel,
                                movieDateLabel,
                                viewerRatingLabel,
                                viewerRatingScoreLabel,
                                progressView,
                                topDivider,
                                overviewLabel,
                                overviewDetailsLabel,
                                bottomDivider])

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            posterImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: UX.padding),
            posterImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: UX.extraPadding),
            posterImage.widthAnchor.constraint(equalToConstant: UX.posterWidth),
            posterImage.heightAnchor.constraint(equalToConstant: UX.posterHeight),
            
            movieTitleLabel.topAnchor.constraint(equalTo: posterImage.topAnchor),
            movieTitleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: UX.padding),
            movieTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UX.padding),
            movieTitleLabel.heightAnchor.constraint(equalToConstant: UX.largeLabelHeight),
            
            movieDateLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor),
            movieDateLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: UX.padding),
            movieDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UX.padding),
            movieDateLabel.heightAnchor.constraint(equalToConstant: UX.smallLabelHeight),
            
            viewerRatingLabel.topAnchor.constraint(equalTo: movieDateLabel.bottomAnchor, constant: UX.extraPadding),
            viewerRatingLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: UX.padding),
            viewerRatingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UX.padding),
            viewerRatingLabel.heightAnchor.constraint(equalToConstant: UX.smallLabelHeight),
            
            viewerRatingScoreLabel.topAnchor.constraint(equalTo: viewerRatingLabel.bottomAnchor),
            viewerRatingScoreLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: UX.padding),
            viewerRatingScoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UX.padding),
            viewerRatingScoreLabel.heightAnchor.constraint(equalToConstant: 30),
            
            progressView.topAnchor.constraint(equalTo: viewerRatingScoreLabel.bottomAnchor, constant: UX.extraPadding),
            progressView.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: UX.padding),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UX.padding),
            progressView.bottomAnchor.constraint(equalTo: posterImage.bottomAnchor),
            
            overviewLabel.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: UX.padding * 2),
            overviewLabel.leadingAnchor.constraint(equalTo: posterImage.leadingAnchor, constant: UX.padding),
            overviewLabel.heightAnchor.constraint(equalToConstant: UX.largeLabelHeight),
            
            topDivider.bottomAnchor.constraint(equalTo: overviewLabel.topAnchor, constant: -UX.padding / 2),
            topDivider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UX.padding),
            topDivider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topDivider.heightAnchor.constraint(equalToConstant: 2),
            
            overviewDetailsLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor),
            overviewDetailsLabel.leadingAnchor.constraint(equalTo: overviewLabel.leadingAnchor),
            overviewDetailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UX.padding),
            
            bottomDivider.topAnchor.constraint(equalTo: overviewDetailsLabel.bottomAnchor, constant: UX.padding),
            bottomDivider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UX.padding),
            bottomDivider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomDivider.heightAnchor.constraint(equalToConstant: 2),
        ])
    }
    
    private func configureElements() {
        guard let viewModel else { return }
        
        Task {
            let image = await viewModel.fetchPosterImageFor(viewModel.movie)
            await MainActor.run(body: {
                posterImage.image = image
            })
        }
        
        movieTitleLabel.text = viewModel.movie.title
        
        movieDateLabel.text = viewModel.movie.releaseDate
        movieDateLabel.textColor = .systemGray
        
        viewerRatingLabel.text = .MovieDetail.ViewerRating
        viewerRatingLabel.textColor = .systemGray
        
        let voterAverage = String(format: "%.1f", viewModel.movie.voteAverage)
        viewerRatingScoreLabel.text = "\(voterAverage)/10"
        
        progressView.setProgress(Float(viewModel.movie.voteAverage) / 10, animated: false)
        
        overviewLabel.text = .MovieDetail.Overview
        overviewLabel.textColor = .systemGray
        
        overviewDetailsLabel.text = viewModel.movie.overview
    }
}
