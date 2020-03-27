//
//  InfoViewController.swift
//  movieAppV5
//
//  Created by Leonardo Diaz on 3/8/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import CoreData


protocol ReloadTable {
    func reloadRemovedFilm(index:Int)
    func reloadAddedFilm()
}

class InfoViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var overView: UITextView!
    @IBOutlet var addButton: CustomButton!
    @IBOutlet var watchListButton: CustomButton!
    
    
    var overview: String?
    var filmImage: UIImage?
    var filmTitle: String?
    var id: Int?
    var filmPoster: String?
    var currentFilm: WatchList?
    var currentIndex: Int?
    
    var reloadDelegate: ReloadTable?
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        setDetails()
        checkFilmAdded()
    }
    
    
    func checkFilmAdded(){
        if let safeID = id{
            if checkIdExists(id: safeID){
                addButton.isHidden = true
                watchListButton.isHidden = false
            } else {
                watchListButton.isHidden = true
            }
        }
    }
    
    
    func setDetails() {
        DispatchQueue.main.async {
            if self.overview == "" {
                self.overView.text = "No Summary :("
            } else {
                self.overView.text = self.overview ?? "No Summary :("
            }
            self.titleLabel.text = self.filmTitle ?? "Network Error"
            self.imageView.image = self.filmImage ?? UIImage(systemName: "film")
            
        }
    }
    
    
    //MARK: - Close Button
    
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //MARK: - Add Button
    
    @IBAction func addButton(_ sender: UIButton) {
        
        let addedAC = UIAlertController(title: "Added to your Watchlist!", message: nil, preferredStyle: .alert)
        present(addedAC, animated: true, completion: dismissDialog)
        
        let watchListFilm = WatchList(context: self.context)
        if let filmid = id{watchListFilm.id = Int64(filmid)}
        if let poster = filmPoster{watchListFilm.poster_path = poster}
        watchListFilm.title = filmTitle
        watchListFilm.overview = overview
        saveFilms()
        reloadDelegate?.reloadAddedFilm()
        addButton.isHidden = true
        watchListButton.isHidden = false
        watchListButton.backgroundColor = #colorLiteral(red: 0.228567034, green: 0.2638508379, blue: 0.3438823223, alpha: 1)
    }
    
    //MARK: - RemoveButton
    
    @IBAction func watchListButton(_ sender: UIButton) {
        let removedAC = UIAlertController(title: "Removed from your WatchList!", message: nil, preferredStyle: .alert)
        present(removedAC, animated: true, completion: dismissDialog)
        
        if let currentFilm = currentFilm, let indexPath = currentIndex{
            context.delete(currentFilm)
            reloadDelegate?.reloadRemovedFilm(index: indexPath)
        } else {
            if let safeId = id{
                let filmFromID = removeFromID(id: safeId)[0]
                context.delete(filmFromID)
                saveFilms()
            }
        }
        
        watchListButton.isHidden = true
        addButton.isHidden = false
        addButton.backgroundColor = #colorLiteral(red: 0.6274509804, green: 0.6470588235, blue: 0.631372549, alpha: 1)
    }
    
    //MARK: - Timer Dismiss
    
    func dismissDialog(){
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats:false, block: {_ in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    
    //MARK: - Match ID for removal and ID Exists Check
    
    func removeFromID(id: Int) -> [WatchList] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WatchList")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        var list = [WatchList]()
        do {
            list = try context.fetch(fetchRequest) as! [WatchList]
        } catch {
            print("error retrieving id")
        }
        return list
    }
    
    
    func checkIdExists(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WatchList")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.count > 0
    }
    
    //MARK: - Save Core Data
    
    func saveFilms(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
}



