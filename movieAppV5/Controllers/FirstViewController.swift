//
//  FirstViewController.swift
//  movieAppV5
//
//  Created by Leonardo Diaz on 3/5/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import SDWebImage

class FirstViewController: UIViewController {
    private let reuseIdentifier = "FilmID"
    private let segueID = "SegueID"
    private var imageURL = URL(string:"https://image.tmdb.org/t/p/w500/")!
    
    @IBOutlet weak var collectionView: UICollectionView!


    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = centerItemsInCollectionView(cellWidth: 245, numberOfItems: 1, spaceBetweenCell: 15, collectionView: collectionView)
        callMovieDB()
    }
    
    //MARK: - Films Request
    
    func callMovieDB(){
        let filmRequest = FetchFilms()
        filmRequest.requestFilms { [weak self] result in
            switch result{
            case.failure(let error):
                print(error)
            case.success(let films):
                self?.filmsNowPlaying = films
            }
        }
    }
    
    var filmsNowPlaying = [Results](){
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.navigationItem.title = "\(self.filmsNowPlaying.count) Films Now Playing"
            }
        }
    }
    
}


//MARK: - CollectionView DataSource
extension FirstViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmsNowPlaying.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NowPlayingCell
        
        let urlImage = imageURL.appendingPathComponent(filmsNowPlaying[indexPath.row].poster_path!)
        cell.imageView.sd_imageIndicator = SDWebImageActivityIndicator.large
        cell.imageView.sd_setImage(with: urlImage, placeholderImage: nil, options: SDWebImageOptions.highPriority)
        return cell
    }

//MARK: - CollectionView Delegates

func centerItemsInCollectionView(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
    let totalWidth = cellWidth * numberOfItems
    let totalSpacingWidth = spaceBetweenCell * (numberOfItems - 1)
    let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
    let rightInset = leftInset
    return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
}

// DidSelect segue here
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueID, sender: self)
    }
    
//MARK: - Perform Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! InfoViewController
        if let index = collectionView.indexPathsForSelectedItems?.first{
            let cell = collectionView.cellForItem(at: index) as! NowPlayingCell
            destinationVC.overview = filmsNowPlaying[index.row].overview
            destinationVC.filmTitle = filmsNowPlaying[index.row].title
            destinationVC.id = filmsNowPlaying[index.row].id
            destinationVC.filmPoster = filmsNowPlaying[index.row].poster_path
            destinationVC.filmImage = cell.imageView.image
        }
        
    }
    

}

