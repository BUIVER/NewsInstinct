//
//  ViewController.swift
//  PropertyList
//
//  Created by Ivan Ermak on 12/7/18.
//  Copyright © 2018 Ivan Ermak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getData().1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyTableViewCell", for: indexPath)
        let properties = getData().0
        var key: UILabel
        var value: UILabel
        var image: UIImageView
        key = UILabel(frame: CGRect(x: 200, y: 0, width: 400, height: 48))
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        value = UILabel(frame: CGRect(x: 450, y: 0, width: 424, height: 50))
        var array : [String] = Array(properties[indexPath.row].allKeys) as! [String]
        for index in 0..<array.count
        {
            switch array[index]
            {
            case "title" : key.text = properties[indexPath.row].value(forKey: array[index]) as? String
            case "subtitle" : value.text = properties[indexPath.row].value(forKey: array[index]) as? String
            case "image_name" : image.image = UIImage(named: properties[indexPath.row].value(forKey: array[index]) as! String)
                
            default: break
                
            }
        }
       
//        cell.isUserInteractionEnabled = false
     
        
        cell.addSubview(image)
        cell.addSubview(value)
        cell.addSubview(key)
        
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        var table: UITableView
       
        table = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        table.register(UITableViewCell.self, forCellReuseIdentifier: "PropertyTableViewCell")
        
        table.dataSource = self
        table.delegate = self
        self.view.addSubview(table)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func getData() -> ([NSDictionary] , Int)
    {
        
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
        var pListData: [NSDictionary] = []
        let pListPath = Bundle.main.path(forResource: "Data", ofType: "plist")
        let pListXMLfile = FileManager.default.contents(atPath: pListPath!)
        do{
            pListData = try PropertyListSerialization.propertyList(from: pListXMLfile!, options: .mutableContainers, format: &propertyListFormat) as! [NSDictionary]
            
        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
        }
        debugPrint(pListData.description)
        return (pListData, pListData.count)
    }
   

}


// Get data using REST API of firebase
