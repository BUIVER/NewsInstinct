//
//  ViewController.swift
//  PropertyList
//
//  Created by Ivan Ermak on 12/7/18.
//  Copyright © 2018 Ivan Ermak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var syncActivityIndicator: UIActivityIndicatorView!
    
    let networkLoad = NetworkLoad()
    let localLoad = CacheLoad()
    var loadedImages : [UIImage] = []
    var check: Bool = false
    var cachedData: [DataStructure]!
    var loadedData : [DataStructure]!
    var idList: [Int32]!
    @IBOutlet weak var table: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (cachedData != nil)
        {
            check = true
            return cachedData.count
        }
        else{
            return loadedData?.count ?? 0}
    }
    
    @IBAction func reload(_ sender: Any) {
        if (cachedData != nil){
            self.syncActivityIndicator.startAnimating()
            
        localLoad.localStorageSyncStarts(data: cachedData)
            table.isHidden = true
        cachedData = nil
             networkLoad.dataDownload(view: self)
            check = false
        }
        table.reloadData()
        
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyTableViewCell", for: indexPath) as! NewsPrototypeCell

        if (check)
        {
            cell.key.text = cachedData[indexPath.row].title
            cell.value.text = cachedData[indexPath.row].subtitle
            cell.images.image = UIImage(data: cachedData[indexPath.row].image as Data) ?? UIImage()
      
        }
        else {
            cell.key.text = loadedData[indexPath.row].title
            cell.value.text = loadedData[indexPath.row].subtitle
             networkLoad.loadImage(url: URL(string: loadedData[indexPath.row].image_ref)!, index: indexPath.row, view: self)
        }
        return cell
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        load.delegate = self
        localLoad.DataLoad(view: self)
        table.dataSource = self
        table.delegate = self
        self.syncActivityIndicator.isHidden = true
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
        
        if let cell = self.table.cellForRow(at: IndexPath(row: index, section: 0)) as? NewsPrototypeCell {
            cell.images.image = Image
            localLoad.localStorageSave(data: loadedData[index], image: Image)
            self.syncActivityIndicator.stopAnimating()
            self.table.isHidden = false
          
        }
    }
   
}
