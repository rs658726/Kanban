//
//  ViewController.swift
//  Kanban
//
//  Created by Réda Slaoui on 07/07/2024.
//

import UIKit

class ViewController: UIViewController {
    
    let headers = ["Section 1", "Section 2", "Section 3", "Section 4"]
    let data = [["One", "Two", "Three"], ["Four", "Five"], ["Six"], ["Seven", "Eight", "Nine"]]
    
    lazy var collectionView: UICollectionView = {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        collectionView.allowsMultipleSelectionDuringEditing = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(
            UICollectionViewListCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "Header"
        )
        return collectionView
    }()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func generateLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(100))
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(470),
                                              heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            let leading: CGFloat = sectionIndex == 0 ? 70 : 25
            section.contentInsets = NSDirectionalEdgeInsets(top: 150, leading: leading, bottom: 50, trailing: 25)
            section.orthogonalScrollingBehavior = .continuous
            let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(470),
                                                    heightDimension: .absolute(150))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }, configuration: configuration)
        return layout
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? UICollectionViewListCell else { fatalError() }
        var configuration = cell.defaultContentConfiguration()

        configuration.text = data[indexPath.section][indexPath.row]
        configuration.textProperties.font = .systemFont(ofSize: 18, weight: .medium)
        cell.contentConfiguration = configuration

        cell.configurationUpdateHandler = { cell, state in
            var background = UIBackgroundConfiguration.listGroupedCell().updated(for: state)
            background.cornerRadius = 10
            background.strokeColor = .separator
            background.strokeWidth = 1
            cell.backgroundConfiguration = background
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "Header",
            for: indexPath
        ) as? UICollectionViewListCell else { fatalError() }
        var configuration = view.defaultContentConfiguration()
        configuration.text = headers[indexPath.section]
        configuration.textProperties.font = .systemFont(ofSize: 21, weight: .bold)
        view.contentConfiguration = configuration
        return view
    }
}

