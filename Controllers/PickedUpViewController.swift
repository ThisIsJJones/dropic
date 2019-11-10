//
//  PickedUpViewController.swift
//  Dropic
//
//  Created by Jordan Jones on 11/9/19.
//  Copyright © 2019 Jordan Jones. All rights reserved.
//

import Foundation
import UIKit

class PickedUpViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let data: [PickedUpMediaModel] = []

    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "MemeCell", bundle: nil), forCellWithReuseIdentifier: "MemeCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeCell
        cell.configure(with: data[indexPath.row])
        return cell
    }
}
