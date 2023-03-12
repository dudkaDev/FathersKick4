//
//  ViewController.swift
//  FathersKick4
//
//  Created by Андрей Абакумов on 10.03.2023.
//

import UIKit

enum Section {
    case main
}

struct Cell: Hashable {
    var number: Int
    var isTap = false
}

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.bounces = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var numbers = [Cell]()
    var dataSource: UITableViewDiffableDataSource<Section, Cell>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupViews()
        fillNumbersArray()
        setConstraints()
        setDelegates()
        setupDataSource()
        updateDataSource()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Task 4"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Shuffle",
            style: .plain,
            target: self,
            action: #selector(shuffleButtonTapped)
        )
        navigationController?.navigationBar.barTintColor = .systemGray6
    }

    private func setupViews() {
        view.backgroundColor = .systemGray6
        
        view.addSubview(tableView)
    }
    
    private func fillNumbersArray() {
        for num in 0...30 {
            numbers.append(Cell(number: num))
        }
    }
    
    private func setDelegates() {
        tableView.delegate = self
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "\(model.number)"
            cell.accessoryType = model.isTap ? .checkmark : .none
            return cell
        })
        dataSource.defaultRowAnimation = .fade
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Cell>()
        snapshot.appendSections([.main])
        snapshot.appendItems(numbers)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func shuffleButtonTapped() {
        numbers.shuffle()
        updateDataSource()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

//MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = dataSource.itemIdentifier(for: indexPath) else { return }
        
        if selectedCell.isTap {
            var updatedCell = selectedCell
            updatedCell.isTap.toggle()
            numbers.removeAll(where: { $0.number == selectedCell.number })
            numbers.insert(updatedCell, at: indexPath.row)
        } else {
            var updatedCell = selectedCell
            updatedCell.isTap.toggle()
            numbers.removeAll(where: { $0.number == selectedCell.number })
            numbers.insert(updatedCell, at: 0)
        }
        
        updateDataSource()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
