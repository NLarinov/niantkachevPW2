//
//  WishMakerViewController.swift
//  niantkachevPW2
//
//  Created by Николай Ткачев on 23/09/2025.
//

import UIKit

final class WishMakerViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let titleTopPadding: CGFloat = 30
        static let descriptionTopPadding: CGFloat = 20
        static let horizontalPadding: CGFloat = 20
        static let stackSpacing: CGFloat = 16
        static let stackCornerRadius: CGFloat = 20
        static let stackTopPadding: CGFloat = 24
        
        static let titleFontSize: CGFloat = 32
        static let descriptionFontSize: CGFloat = 18
        
        static let segmentTopPadding: CGFloat = 20
        static let buttonTopPadding: CGFloat = 12
        static let buttonHeight: CGFloat = 44
        static let addWishButtonText: String = "Write Down Wish"
        static let scheduleWishButtonText: String = "Schedule Wish"
        static let addWishButtonBottomPadding: CGFloat = 40
        static let addWishButtonHorizontalPadding: CGFloat = 24
        static let addWishButtonCornerRadius: CGFloat = 22
        static let stackBottom: CGFloat = 40
        static let stackLeading: CGFloat = 24
        static let spacing: CGFloat = 16
    }
    
    // MARK: - UI Components
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let modeSegmentedControl: UISegmentedControl = {
        let items = ["HEX", "Picker", "Random"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Hide Sliders", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stack = UIStackView()
    private let addWishButton: UIButton = UIButton(type: .system)
    private let scheduleWishesButton: UIButton = UIButton(type: .system)
    private let actionStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let sliderRed = CustomSlider(title: "Red", min: 0, max: 1)
    private let sliderGreen = CustomSlider(title: "Green", min: 0, max: 1)
    private let sliderBlue = CustomSlider(title: "Blue", min: 0, max: 1)
    
    // MARK: - Public Properties
    var currentBackgroundColor: UIColor = .systemPink {
        didSet {
            updateButtonColors()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        currentBackgroundColor = .systemPink
        
        configureTitle()
        configureDescription()
        configureSegmentedControl()
        configureButton()
        configureActionStack()
        configureSliders()
        setupSliderBindings()
        setupActions()
    }
    
    // MARK: - Title
    private func configureTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "WishMaker"
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.titleFontSize)
        titleLabel.textColor = .systemBlue
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTopPadding)
        ])
    }
    
    // MARK: - Description
    private func configureDescription() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Make your wishes come true by changing colors!"
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.descriptionTopPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding)
        ])
    }
    
    // MARK: - Segmented Control
    private func configureSegmentedControl() {
        view.addSubview(modeSegmentedControl)
        NSLayoutConstraint.activate([
            modeSegmentedControl.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.segmentTopPadding),
            modeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Toggle Button
    private func configureButton() {
        view.addSubview(toggleButton)
        NSLayoutConstraint.activate([
            toggleButton.topAnchor.constraint(equalTo: modeSegmentedControl.bottomAnchor, constant: Constants.buttonTopPadding),
            toggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
    // MARK: - Action Stack
    private func configureActionStack() {
        actionStack.axis = .vertical
        view.addSubview(actionStack)
        actionStack.spacing = Constants.spacing
        for button in [addWishButton, scheduleWishesButton] {
            actionStack.addArrangedSubview(button)
        }
        configureAddMoreWishes()
        configureScheduleMissions()
        actionStack.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.stackBottom)
        actionStack.pinHorizontal(to: view, Constants.stackLeading)
    }
    
    // MARK: - Add Wish Button
    private func configureAddMoreWishes() {
        addWishButton.translatesAutoresizingMaskIntoConstraints = false
        addWishButton.backgroundColor = .white
        addWishButton.setTitle(Constants.addWishButtonText, for: .normal)
        addWishButton.layer.cornerRadius = Constants.addWishButtonCornerRadius
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
        addWishButton.setHeight(Constants.buttonHeight)
        updateButtonColors()
    }
    
    // MARK: - Schedule Button
    private func configureScheduleMissions() {
        scheduleWishesButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleWishesButton.backgroundColor = .white
        scheduleWishesButton.setTitle(Constants.scheduleWishButtonText, for: .normal)
        scheduleWishesButton.layer.cornerRadius = Constants.addWishButtonCornerRadius
        scheduleWishesButton.addTarget(self, action: #selector(scheduleWishButtonPressed), for: .touchUpInside)
        scheduleWishesButton.setHeight(Constants.buttonHeight)
        updateButtonColors()
    }
    
    // MARK: - Update Button Colors
    private func updateButtonColors() {
        addWishButton.setTitleColor(currentBackgroundColor, for: .normal)
        scheduleWishesButton.setTitleColor(currentBackgroundColor, for: .normal)
    }
    
    // MARK: - Sliders
    private func configureSliders() {
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layer.cornerRadius = Constants.stackCornerRadius
        stack.clipsToBounds = true
        
        for slider in [sliderRed, sliderGreen, sliderBlue] {
            stack.addArrangedSubview(slider)
        }
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            stack.topAnchor.constraint(equalTo: toggleButton.bottomAnchor, constant: Constants.stackTopPadding),
            stack.bottomAnchor.constraint(equalTo: actionStack.topAnchor, constant: -Constants.stackTopPadding)
        ])
    }
    
    // MARK: - Slider Logic
    private func setupSliderBindings() {
        sliderRed.valueChanged = { [weak self] _ in self?.updateBackgroundColorFromSliders() }
        sliderGreen.valueChanged = { [weak self] _ in self?.updateBackgroundColorFromSliders() }
        sliderBlue.valueChanged = { [weak self] _ in self?.updateBackgroundColorFromSliders() }
    }
    
    private func updateBackgroundColorFromSliders() {
        let red = CGFloat(sliderRed.slider.value)
        let green = CGFloat(sliderGreen.slider.value)
        let blue = CGFloat(sliderBlue.slider.value)
        
        let newColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        view.backgroundColor = newColor
        currentBackgroundColor = newColor
    }
    
    // MARK: - Actions
    private func setupActions() {
        toggleButton.addTarget(self, action: #selector(toggleSliders), for: .touchUpInside)
        modeSegmentedControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
    }
    
    @objc private func toggleSliders() {
        let shouldHide = !stack.isHidden
        stack.isHidden = shouldHide
        toggleButton.setTitle(shouldHide ? "Show Sliders" : "Hide Sliders", for: .normal)
    }
    
    @objc private func modeChanged() {
        stack.isHidden = true
        toggleButton.isHidden = true
        
        switch modeSegmentedControl.selectedSegmentIndex {
        case 0: // HEX
            let bgColor = UIColor.systemBackground
            view.backgroundColor = bgColor
            currentBackgroundColor = bgColor
            stack.isHidden = false
            toggleButton.isHidden = false
        case 1: // Picker
            let picker = UIColorPickerViewController()
            picker.selectedColor = view.backgroundColor ?? .white
            picker.delegate = self
            present(picker, animated: true)
        case 2: // Random
            let randomColor = UIColor(
                red: .random(in: 0...1),
                green: .random(in: 0...1),
                blue: .random(in: 0...1),
                alpha: 1.0
            )
            view.backgroundColor = randomColor
            currentBackgroundColor = randomColor
        default: break
        }
    }
    
    @objc
    private func addWishButtonPressed() {
        let storingController = WishStoringViewController()
        storingController.modalPresentationStyle = .pageSheet
        storingController.view.backgroundColor = currentBackgroundColor
        present(storingController, animated: true)
    }
    
    @objc
    private func scheduleWishButtonPressed() {
        let vc = WishCalendarViewController()
        vc.view.backgroundColor = currentBackgroundColor
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UIColorPicker Delegate
extension WishMakerViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        view.backgroundColor = viewController.selectedColor
        currentBackgroundColor = viewController.selectedColor
    }
}

// MARK: - UIColor Extension for HEX
extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
