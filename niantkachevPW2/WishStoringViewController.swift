//
//  WishStoringViewController.swift
//  niantkachevPW2
//
//  Created by Николай Ткачев on 21/10/2025.
//

import UIKit

final class WishStoringViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let backgroundColor: UIColor = .systemGroupedBackground
        static let wishesKey: String = "WishStoringViewController.wishes"
        static let tableCornerRadius: CGFloat = 20
        static let tableInset: CGFloat = 20
        static let headerTopPadding: CGFloat = 24
        static let headerHorizontalPadding: CGFloat = 24
        static let headerSpacing: CGFloat = 16
        static let dismissButtonTitle: String = "Close"
        static let title: String = "Stored Wishes"
        static let titleFontSize: CGFloat = 28
    }
    
    // MARK: - Properties
    private let tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    private let defaults = UserDefaults.standard
    private var wishes: [String] = [] {
        didSet { persistWishes() }
    }
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        label.textAlignment = .center
        label.text = Constants.title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.dismissButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backgroundColor
        
        configureHeader()
        configureTable()
        loadWishes()
    }
    
    // MARK: - Setup
    private func configureHeader() {
        view.addSubview(headerLabel)
        view.addSubview(dismissButton)
        
        dismissButton.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.headerTopPadding),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.headerHorizontalPadding),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.headerHorizontalPadding),
            
            dismissButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.headerHorizontalPadding)
        ])
    }
    
    private func configureTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = Constants.tableCornerRadius
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
        tableView.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: Constants.headerSpacing),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.tableInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.tableInset),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.tableInset)
        ])
    }
    
    // MARK: - Persistence
    private func loadWishes() {
        let stored = defaults.stringArray(forKey: Constants.wishesKey) ?? []
        wishes = stored
        tableView.reloadData()
    }
    
    private func persistWishes() {
        defaults.set(wishes, forKey: Constants.wishesKey)
    }
    
    // MARK: - Helpers
    private func appendWish(_ wish: String) {
        wishes.append(wish)
        reloadWrittenWishes()
    }
    
    private func updateWish(at index: Int, with newValue: String) {
        guard wishes.indices.contains(index) else { return }
        wishes[index] = newValue
        reloadWrittenWishes()
    }
    
    private func removeWish(at index: Int) {
        guard wishes.indices.contains(index) else { return }
        wishes.remove(at: index)
        reloadWrittenWishes()
    }
    
    private func reloadWrittenWishes() {
        let writtenSection = IndexSet(integer: 1)
        tableView.reloadSections(writtenSection, with: .automatic)
    }
    
    private func presentEditAlert(for index: Int) {
        guard wishes.indices.contains(index) else { return }
        let alert = UIAlertController(title: "Edit Wish", message: "Update your stored wish.", preferredStyle: .alert)
        alert.addTextField { [weak self] textField in
            textField.text = self?.wishes[index]
            textField.placeholder = "Type your wish"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let text = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !text.isEmpty else { return }
            self?.updateWish(at: index, with: text)
        }))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc
    private func dismissScreen() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return wishes.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.reuseId, for: indexPath) as? AddWishCell else {
                return UITableViewCell()
            }
            cell.addWish = { [weak self] wish in
                self?.appendWish(wish)
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath) as? WrittenWishCell else {
                return UITableViewCell()
            }
            cell.configure(with: wishes[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension WishStoringViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 1 else { return }
        presentEditAlert(for: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 1 else { return nil }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.removeWish(at: indexPath.row)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 1 else { return nil }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completion in
            self?.presentEditAlert(for: indexPath.row)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [editAction])
    }
}

// MARK: - AddWishCell
final class AddWishCell: UITableViewCell {
    
    static let reuseId: String = "AddWishCell"
    
    // MARK: - Constants
    private enum Constants {
        static let backgroundColor: UIColor = .systemBackground
        static let containerInset: CGFloat = 12
        static let contentPadding: CGFloat = 16
        static let textViewHeight: CGFloat = 120
        static let buttonHeight: CGFloat = 44
        static let containerCornerRadius: CGFloat = 20
    }
    
    // MARK: - Public
    var addWish: ((String) -> Void)?
    
    // MARK: - UI
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.backgroundColor
        view.layer.cornerRadius = Constants.containerCornerRadius
        return view
    }()
    
    private let wishTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.backgroundColor = .systemGray6
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        return textView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Wish", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(wishTextView)
        containerView.addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.containerInset),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.containerInset),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.containerInset),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.containerInset),
            
            wishTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.contentPadding),
            wishTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.contentPadding),
            wishTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.contentPadding),
            wishTextView.heightAnchor.constraint(equalToConstant: Constants.textViewHeight),
            
            addButton.topAnchor.constraint(equalTo: wishTextView.bottomAnchor, constant: Constants.contentPadding),
            addButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.contentPadding),
            addButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.contentPadding),
            addButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.contentPadding),
            addButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        addWish = nil
        wishTextView.text = ""
    }
    
    // MARK: - Actions
    @objc
    private func addButtonTapped() {
        let text = wishTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        addWish?(text)
        wishTextView.text = ""
        wishTextView.resignFirstResponder()
    }
}

// MARK: - WrittenWishCell
final class WrittenWishCell: UITableViewCell {
    
    static let reuseId: String = "WrittenWishCell"
    
    private enum Constants {
        static let wrapColor: UIColor = .systemPink
        static let wrapRadius: CGFloat = 16
        static let wrapOffsetV: CGFloat = 5
        static let wrapOffsetH: CGFloat = 10
        static let wishLabelOffset: CGFloat = 8
    }
    
    private let wishLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with wish: String) {
        wishLabel.text = wish
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        let wrap = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius
        
        contentView.addSubview(wrap)
        wrap.addSubview(wishLabel)
        
        NSLayoutConstraint.activate([
            wrap.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.wrapOffsetV),
            wrap.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.wrapOffsetV),
            wrap.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.wrapOffsetH),
            wrap.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.wrapOffsetH),
            
            wishLabel.topAnchor.constraint(equalTo: wrap.topAnchor, constant: Constants.wishLabelOffset),
            wishLabel.bottomAnchor.constraint(equalTo: wrap.bottomAnchor, constant: -Constants.wishLabelOffset),
            wishLabel.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: Constants.wishLabelOffset),
            wishLabel.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -Constants.wishLabelOffset)
        ])
    }
}
