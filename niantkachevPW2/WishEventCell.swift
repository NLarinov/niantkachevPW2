//
//  WishEventCell.swift
//  niantkachevPW2
//
//  Created by Николай Ткачев on 25/11/2025.
//

import UIKit

final class WishEventCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "WishEventCell"
    
    // MARK: - Constants
    private enum Constants {
        static let offset: CGFloat = 5
        static let cornerRadius: CGFloat = 16
        static let backgroundColor: UIColor = .systemBackground
        static let titleTop: CGFloat = 12
        static let titleLeading: CGFloat = 16
        static let titleFontSize: CGFloat = 18
        static let descriptionTop: CGFloat = 8
        static let descriptionLeading: CGFloat = 16
        static let descriptionFontSize: CGFloat = 14
        static let dateTop: CGFloat = 8
        static let dateLeading: CGFloat = 16
        static let dateFontSize: CGFloat = 12
        static let spacing: CGFloat = 4
    }
    
    // MARK: - UI Components
    private let wrapView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let startDateLabel: UILabel = UILabel()
    private let endDateLabel: UILabel = UILabel()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureWrap()
        configureTitleLabel()
        configureDescriptionLabel()
        configureStartDateLabel()
        configureEndDateLabel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Configuration
    func configure(with event: WishEventModel) {
        titleLabel.text = event.title
        descriptionLabel.text = event.description
        startDateLabel.text = "Start: \(event.startDateString)"
        endDateLabel.text = "End: \(event.endDateString)"
    }
    
    // MARK: - UI Configuration
    private func configureWrap() {
        addSubview(wrapView)
        wrapView.pin(to: self, Constants.offset)
        wrapView.layer.cornerRadius = Constants.cornerRadius
        wrapView.backgroundColor = Constants.backgroundColor
        wrapView.layer.shadowColor = UIColor.black.cgColor
        wrapView.layer.shadowOffset = CGSize(width: 0, height: 2)
        wrapView.layer.shadowRadius = 4
        wrapView.layer.shadowOpacity = 0.1
    }
    
    private func configureTitleLabel() {
        wrapView.addSubview(titleLabel)
        titleLabel.textColor = .label
        titleLabel.pinTop(to: wrapView, Constants.titleTop)
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.titleFontSize)
        titleLabel.pinLeading(to: wrapView, Constants.titleLeading)
        titleLabel.pinTrailing(to: wrapView, Constants.titleLeading)
    }
    
    private func configureDescriptionLabel() {
        wrapView.addSubview(descriptionLabel)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionTop)
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        descriptionLabel.pinLeading(to: wrapView, Constants.descriptionLeading)
        descriptionLabel.pinTrailing(to: wrapView, Constants.descriptionLeading)
        descriptionLabel.numberOfLines = 2
    }
    
    private func configureStartDateLabel() {
        wrapView.addSubview(startDateLabel)
        startDateLabel.textColor = .systemBlue
        startDateLabel.pinTop(to: descriptionLabel.bottomAnchor, Constants.dateTop)
        startDateLabel.font = UIFont.systemFont(ofSize: Constants.dateFontSize)
        startDateLabel.pinLeading(to: wrapView, Constants.dateLeading)
    }
    
    private func configureEndDateLabel() {
        wrapView.addSubview(endDateLabel)
        endDateLabel.textColor = .systemBlue
        endDateLabel.pinTop(to: startDateLabel.bottomAnchor, Constants.spacing)
        endDateLabel.font = UIFont.systemFont(ofSize: Constants.dateFontSize)
        endDateLabel.pinLeading(to: wrapView, Constants.dateLeading)
        endDateLabel.pinBottom(to: wrapView, Constants.dateTop)
    }
}

