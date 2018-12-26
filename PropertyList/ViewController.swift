//
//  ViewController.swift
//  PropertyList
//
//  Created by Ivan Ermak on 12/7/18.
//  Copyright © 2018 Ivan Ermak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let load = DataLoad()
    var loadedImages : [UIImage] = []
    var loadedData : [DataStructure]!
    @IBOutlet weak var table: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        
      return loadedData?.count ?? 0
    }
    
    @IBAction func reload(_ sender: Any) {
        table.reloadData()
        
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyTableViewCell", for: indexPath) as! PrototypeCell

        
        
        cell.key.text = loadedData[indexPath.row].title
        cell.value.text = loadedData[indexPath.row].subtitle
        
        load.loadImage(url: URL(string: loadedData[indexPath.row].image_ref)!, index: indexPath.row, view: self)
        
        return cell
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        load.delegate = self
        load.DataLoad(view: self)
        table.dataSource = self
        table.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
  
}

extension ViewController /*: DataLoadDelegate*/ {
    func loadCompleted(data: [DataStructure]) {
        self.loadedData = data
        for _ in 0..<loadedData.count
        {
        self.loadedImages.append(UIImage())
        }
        self.table.reloadData()
    }
    
    func imageLoadCompleted(Image: UIImage, index: Int)
    {
        self.loadedImages[index] = Image
//         self.table.reloadData()
        
        if let cell = self.table.cellForRow(at: IndexPath(row: index, section: 0)) as? PrototypeCell {
            cell.images.image = Image
        }
    }
   
}
