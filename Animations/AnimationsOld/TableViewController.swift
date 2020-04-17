//
//  TableViewController.swift
//  Animations
//
//  Created by admin on 04/02/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    weak var tableView:UITableView!
    
    override func loadView() {
        super.loadView()
        
        let tempTableView = UITableView()
        tempTableView.backgroundColor = .white
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tempTableView)
        NSLayoutConstraint.activate([
            tempTableView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor),
            tempTableView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor),
            tempTableView.safeAreaLayoutGuide.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tempTableView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView = tempTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "contactCell")
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(tap(_:)))
        tableView.addGestureRecognizer(tapGesture)
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(pan(_: )))
        tableView.addGestureRecognizer(panGesture)
        
        someFunction()
    }
    
    @objc func pan(_ panGesture:UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            print("began")
        case .changed:
            print("changed")
        case .ended:
            print("ended")
        default:
            break
        }
    }
    @objc func tap(_ gesture:UITapGestureRecognizer) {
        let translation = gesture.location(in: gesture.view)
        let point = view.convert(translation, from: tableView)
        print(point)
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) != nil else { return }
    }
    
    func someFunction() {
        var scores = ["Sophie": 5, "James": 2]
        let result = scores.updateValue(3, forKey: "James")
        print(result as Any)
    }
}
