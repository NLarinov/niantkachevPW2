//
//  WishEventCreationView.swift
//  niantkachevPW2
//
//  Created by Николай Ткачев on 25/11/2025.
//

import UIKit

final class WishEventCreationView: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let backgroundColor: UIColor = .systemGroupedBackground
        static let title: String = "Create Wish Event"
        static let titleFontSize: CGFloat = 24
        static let padding: CGFloat = 20
        static let spacing: CGFloat = 16
        static let buttonHeight: CGFloat = 44
        static let cornerRadius: CGFloat = 12
        static let textFieldHeight: CGFloat = 44
        static let textViewHeight: CGFloat = 100
        static let wishesKey: String = "WishStoringViewController.wishes"
    }
    
    // MARK: - Properties
    var onEventCreated: ((WishEventModel) -> Void)?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.title
        label.font = UIFont.boldSystemFont(ofSize: Constants.titleFontSize)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Event Title"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = Constants.cornerRadius
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let descriptionPlaceholder: UILabel = {
        let label = UILabel()
        label.text = "Event Description"
        label.textColor = .placeholderText
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.minimumDate = Date()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.minimumDate = Date().addingTimeInterval(3600) // 1 hour from now
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let wishPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let wishLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Wish (Optional):"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Event", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let defaults = UserDefaults.standard
    private var wishes: [String] = []
    private var selectedWishIndex: Int = 0
    
    // MARK: - Properties
    var backgroundColor: UIColor? {
        didSet {
            if let bgColor = backgroundColor {
                view.backgroundColor = bgColor
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor ?? Constants.backgroundColor
        
        loadWishes()
        setupUI()
        setupActions()
        setupTextViewPlaceholder()
    }
    
    // MARK: - Setup
    private func loadWishes() {
        wishes = defaults.stringArray(forKey: Constants.wishesKey) ?? []
        if wishes.isEmpty {
            wishes.append("No wishes available")
        }
        // Set end date to 1 hour after start date
        endDatePicker.date = startDatePicker.date.addingTimeInterval(3600)
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(descriptionPlaceholder)
        contentView.addSubview(startDatePicker)
        contentView.addSubview(endDatePicker)
        contentView.addSubview(wishLabel)
        contentView.addSubview(wishPicker)
        contentView.addSubview(createButton)
        contentView.addSubview(cancelButton)
        
        wishPicker.delegate = self
        wishPicker.dataSource = self
        
        setupKeyboardDismissal()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            titleTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: Constants.spacing),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            descriptionTextView.heightAnchor.constraint(equalToConstant: Constants.textViewHeight),
            
            descriptionPlaceholder.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 8),
            descriptionPlaceholder.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 8),
            
            startDatePicker.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: Constants.spacing),
            startDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            startDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            
            endDatePicker.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: Constants.spacing),
            endDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            endDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            
            wishLabel.topAnchor.constraint(equalTo: endDatePicker.bottomAnchor, constant: Constants.spacing),
            wishLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            wishLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            
            wishPicker.topAnchor.constraint(equalTo: wishLabel.bottomAnchor, constant: Constants.spacing),
            wishPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            wishPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            wishPicker.heightAnchor.constraint(equalToConstant: 100),
            
            createButton.topAnchor.constraint(equalTo: wishPicker.bottomAnchor, constant: Constants.spacing * 2),
            createButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            createButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            cancelButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: Constants.spacing),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding)
        ])
    }
    
    private func setupActions() {
        createButton.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
    }
    
    // MARK: - Keyboard Dismissal
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func startDateChanged() {
        endDatePicker.minimumDate = startDatePicker.date.addingTimeInterval(60) // At least 1 minute after start
    }
    
    private func setupTextViewPlaceholder() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textViewDidChange),
            name: UITextView.textDidChangeNotification,
            object: descriptionTextView
        )
    }
    
    @objc private func textViewDidChange() {
        descriptionPlaceholder.isHidden = !descriptionTextView.text.isEmpty
    }
    
    // MARK: - Actions
    @objc private func createButtonPressed() {
        dismissKeyboard()
        
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !title.isEmpty else {
            showAlert(message: "Please enter an event title")
            return
        }
        
        let description = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        guard endDate > startDate else {
            showAlert(message: "End date must be after start date")
            return
        }
        
        let selectedWish = (wishes.count > 0 && selectedWishIndex < wishes.count && wishes[selectedWishIndex] != "No wishes available") ? wishes[selectedWishIndex] : nil
        
        let event = WishEventModel(
            title: title,
            description: description.isEmpty ? "No description" : description,
            startDate: startDate,
            endDate: endDate,
            wishTitle: selectedWish
        )
        
        // Create calendar event
        let calendarManager = CalendarManager()
        let calendarEvent = CalendarEventModel(
            title: title,
            startDate: startDate,
            endDate: endDate,
            note: description.isEmpty ? nil : description
        )
        _ = calendarManager.create(eventModel: calendarEvent)
        
        onEventCreated?(event)
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonPressed() {
        dismiss(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIPickerViewDataSource & Delegate
extension WishEventCreationView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wishes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wishes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedWishIndex = row
    }
}

