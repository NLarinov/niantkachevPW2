//
//  CustomSliderView.swift
//  niantkachevPW2
//
//  Created by Николай Ткачев on 23/09/2025.
//

import UIKit

final class CustomSlider: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let verticalPadding: CGFloat = 10
        static let horizontalPadding: CGFloat = 20
        static let titleFontSize: CGFloat = 16
        static let valueFontSize: CGFloat = 14
    }
    
    // MARK: - Public
    var valueChanged: ((Double) -> Void)?
    
    // MARK: - UI Components
    let slider = UISlider()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    // MARK: - Init
    init(title: String, min: Double, max: Double) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .medium)
        
        valueLabel.font = UIFont.systemFont(ofSize: Constants.valueFontSize)
        valueLabel.textColor = .darkGray
        valueLabel.text = "\(min)"
        
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        for view in [titleLabel, valueLabel, slider] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPadding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            
            valueLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            
            slider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.verticalPadding),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding)
        ])
    }
    
    // MARK: - Actions
    @objc
    private func sliderValueChanged() {
        let newValue = Double(slider.value)
        valueLabel.text = String(format: "%.2f", newValue)
        valueChanged?(newValue)
    }
}
