//
//  CollectionViewController.swift
//  Animations
//
//  Created by admin on 04/02/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {

    weak var collectionView:UICollectionView!
    var dataSource = [String]()
    override func loadView() {
        super.loadView()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let widthHeight = view.frame.width/3 - 10
        flowLayout.itemSize = CGSize(width:widthHeight, height:150)
        
        let tempCollectionView = UICollectionView(frame:.zero, collectionViewLayout: flowLayout)
        tempCollectionView.backgroundColor = .white
        tempCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        tempCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tempCollectionView)
        NSLayoutConstraint.activate([
            tempCollectionView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor),
            tempCollectionView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor),
            tempCollectionView.safeAreaLayoutGuide.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            tempCollectionView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionView = tempCollectionView
    }
    
    private let reuseIdentifier = "FlickrCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .red
//        collectionView.delegate = self
        collectionView.dataSource = self
    }

}


extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.contentView.backgroundColor = .gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.transition(with: cell!.contentView, duration: 2, options: [.curveEaseInOut, .transitionCurlUp], animations: nil, completion: nil)
//        apiCall()
    }
 
    func apiCall() {
        var request2 = URLRequest.init(url: URL.init(string: "https://httpstat.us/200")!)
        let session = URLSession.shared
        request2.httpMethod = "GET"
        request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request2.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request2, completionHandler: {(data, response, error) in
              if error != nil {
                  print("Error: \(String(describing: error))")
              } else {
                  print("Response: \(String(describing: response))")
              }
         })
        
    }
}
