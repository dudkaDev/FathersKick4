//
//  ViewController.swift
//  FathersKick4
//
//  Created by Андрей Абакумов on 10.03.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let idTableViewCell = "idTableViewCell"
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 10
        tableView.bounces = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setupNavBar()
        setupViews()
        setConstraints()
        setDelegates()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: idTableViewCell)
        
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
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func shuffleButtonTapped() {
        var cellIndexes = [Int]()
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            cellIndexes.append(i)
        }
        cellIndexes.shuffle()
        
        tableView.beginUpdates()
        for i in 0..<cellIndexes.count {
            let indexPath = IndexPath(row: cellIndexes[i], section: 0)
            tableView.moveRow(at: indexPath, to: IndexPath(row: i, section: 0))
        }
        tableView.endUpdates()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idTableViewCell, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            let destinationIndexPath = NSIndexPath(row: 0, section: indexPath.section)
            tableView.moveRow(at: indexPath, to: destinationIndexPath as IndexPath)
        }
    }
}

//MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}

