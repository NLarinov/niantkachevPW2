//
//  WishCalendarViewController.swift
//  niantkachevPW2
//
//  Created by Николай Ткачев on 25/11/2025.
//

import UIKit

final class WishCalendarViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let contentInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let collectionTop: CGFloat = 20
        static let eventsKey: String = "WishCalendarViewController.events"
    }
    
    // MARK: - Properties
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private let defaults = UserDefaults.standard
    private var events: [WishEventModel] = [] {
        didSet {
            persistEvents()
        }
    }
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wish Calendar"
        navigationItem.rightBarButtonItem = addButton
        
        configureCollection()
        loadEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Background color is set when pushed from WishMakerViewController
    }
    
    // MARK: - Configuration
    private func configureCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = Constants.contentInset
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            layout.invalidateLayout()
        }
        
        collectionView.register(
            WishEventCell.self,
            forCellWithReuseIdentifier: WishEventCell.reuseIdentifier
        )
        
        view.addSubview(collectionView)
        collectionView.pinHorizontal(to: view)
        collectionView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.collectionTop)
    }
    
    // MARK: - Persistence
    private func loadEvents() {
        if let data = defaults.data(forKey: Constants.eventsKey),
           let decoded = try? JSONDecoder().decode([WishEventModel].self, from: data) {
            events = decoded
            collectionView.reloadData()
        }
    }
    
    private func persistEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            defaults.set(encoded, forKey: Constants.eventsKey)
        }
    }
    
    // MARK: - Actions
    @objc
    private func addButtonPressed() {
        let creationView = WishEventCreationView()
        creationView.modalPresentationStyle = .pageSheet
        creationView.backgroundColor = view.backgroundColor
        creationView.onEventCreated = { [weak self] event in
            self?.events.append(event)
            self?.collectionView.reloadData()
        }
        present(creationView, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishEventCell.reuseIdentifier, for: indexPath)
        guard let wishEventCell = cell as? WishEventCell else {
            return cell
        }
        wishEventCell.configure(with: events[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WishCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell tapped at index \(indexPath.item)")
    }
}

