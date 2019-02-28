//
//  ViewController.swift
//  PropertyList
//
//  Created by Ivan Ermak on 12/7/18.
//  Copyright © 2018 Ivan Ermak. All rights reserved.
//


import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate{
    
    @IBOutlet weak var syncActivityIndicator: UIActivityIndicatorView!
    
   
    
    var localLoad: CacheLoad!
    var networkLoad = LoadDataFromNetwork()
    var loadImage: ImageLoader!
    var idList: [Int32]!
    var object : News?
    @IBOutlet weak var table: UITableView!
    @IBAction func reload(_ sender: Any) {
    
        self.syncActivityIndicator.startAnimating()
        networkLoad.dataDownload()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        localLoad = CacheLoad(delegate: self)
        loadImage = ImageLoader()
        localLoad.mainDelegate = self
        networkLoad.delegate = self
        localLoad.loadData()
        table.dataSource = self
        table.delegate = self 
        // Do any additional setup after loading the view, typically from a nib.
    }
   
}

extension ViewController
{
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "ShowDetailed":
            guard let editViewController = segue.destination as? DetailedViewController else {
                fatalError("unexpected destination: \(segue.destination)")
            }
            guard let editedTableCell = sender as? NewsTableCell else {
                fatalError("unexpected sender: \(sender ?? "")")
            }
            guard let indexPath = table.indexPath(for: editedTableCell) else {
                fatalError("there's no such cell in table")
            }
            let object = self.localLoad.fetchedResultController.object(at: indexPath)
            editViewController.dataToEdit = object
            if let url = URL(string: object.imageUrl ?? ""){
            loadImage.loadImage(url: url, completion: {image in
                editViewController.imageView.image = image
             
            })
            }
        case "AddItem": break
            
        default:
            fatalError("Unknown segue identifier:\(segue.identifier ?? "")")
        }
    }
}


extension ViewController : CachedLoadDelegate
{
    func syncCompleted()
    {
        self.syncActivityIndicator.stopAnimating()
    }
    
}

extension ViewController: DataLoadDelegate
{
    func dataLoadCompleted(data: [NetworkLoadStructure]) {
        
        localLoad.startSync(data: data)
    }
    
    
}

extension ViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.localLoad.fetchedResultController.sections else { return 0}
        return sections[section].numberOfObjects
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyTableViewCell", for: indexPath) as! NewsTableCell
        let data = self.localLoad.fetchedResultController.object(at: indexPath)
        configureCell(cell: cell, data: data, index: indexPath.row)
        return cell
    }
    
    func configureCell(cell: NewsTableCell, data: News, index: Int) {
        
        let cellValue = data
        
        cell.key.text = cellValue.title
        cell.value.text = cellValue.subtitle
        if let url = URL(string: cellValue.imageUrl ?? "") {
            loadImage.loadImage(url: url) {image in
                
                
                    if (self.table.indexPathsForVisibleRows?.contains(IndexPath(row: index, section: 0)) ?? false){
                    cell.images.image = image
                }
        }
        }
    }
}


extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.beginUpdates()
    }
   
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            table.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            table.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                table.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                table.reloadRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                table.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                table.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                table.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
  
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.endUpdates()
    }
}
