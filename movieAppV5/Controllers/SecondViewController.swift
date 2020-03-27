//
//  SecondViewController.swift
//  movieAppV5
//
//  Created by Leonardo Diaz on 3/5/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class SecondViewController: UIViewController {

    private let reuseIdentifier = "WatchListFilms"
    private let segueID = "WatchListID"
    private var imageURL = URL(string:"https://image.tmdb.org/t/p/w500/")!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "My WatchList"
        navigationController?.navigationBar.prefersLargeTitles = true
        loadFilms()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFilms()
    }
    
    //MARK: - Load Core Data
    
    func loadFilms(){
        let request : NSFetchRequest<WatchList> = WatchList.fetchRequest()
        do {
            watchlist = try context.fetch(request)
        } catch {
            print("Error retrieving data from context \(error)")
        }
    }
    
    
    var watchlist = [WatchList](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Save Core Data
    
    func saveFilms(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    

}

    //MARK: - TableView Delegates

extension SecondViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier , for: indexPath) as! WatchListCell
        
        let urlImage = imageURL.appendingPathComponent(watchlist[indexPath.row].poster_path!)
        cell.myListImage.sd_imageIndicator = SDWebImageActivityIndicator.large
        cell.myListImage.sd_setImage(with: urlImage, placeholderImage: nil, options: SDWebImageOptions.highPriority)
        cell.filmTitle.text = watchlist[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueID, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    //MARK: - Delete Core Data / TableView Cell
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Add a are you sure Alert?
        let promptOptions = UIContextualAction(style: .destructive, title: "Remove") {  (action, view, boolValue) in
            self.showDeleteWarning(for: indexPath)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [promptOptions])
        return swipeActions
    }
    
    func showDeleteWarning(for indexPath: IndexPath){
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to remove this from your list?", preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (delete) in
            self.context.delete(self.watchlist[indexPath.row])
            self.watchlist.remove(at: indexPath.row)
            self.saveFilms()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(delete)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
    
}
    //MARK: - Prepare Segue

extension SecondViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! InfoViewController
        
        if let index = tableView.indexPathForSelectedRow{
            let cell = tableView.cellForRow(at: index) as! WatchListCell
            let intId = Int(watchlist[index.row].id)
            destinationVC.id = intId
            destinationVC.filmTitle = watchlist[index.row].title
            destinationVC.filmPoster = watchlist[index.row].poster_path
            destinationVC.overview = watchlist[index.row].overview
            destinationVC.currentFilm = watchlist[index.row]
            destinationVC.filmImage = cell.myListImage.image
            destinationVC.currentIndex = index.row
            destinationVC.reloadDelegate = self
        }
    }
}

extension SecondViewController: ReloadTable{
    func reloadRemovedFilm(index: Int) {
        watchlist.remove(at: index)
        saveFilms()
        tableView.reloadData()
    }
    
    func reloadAddedFilm() {
        loadFilms()
        tableView.reloadData()
    }

}

