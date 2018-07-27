//
//  MAMovieListCell.swift
//  TheMovieApp
//
//  Created by Lucas Veras Aguiar Cardoso on 19/07/18.
//  Copyright © 2018 Lucas Veras Aguiar Cardoso. All rights reserved.
//

import UIKit
import RxSwift

class MAMovieListCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    
    @IBOutlet weak var movieImageActivityIndicator: UIActivityIndicatorView!
    
    private var disposable: Disposable?
    
    var movie: MAMovie? {
        didSet{
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImageActivityIndicator.isHidden = true
    }
    
    private func configureCell(){
        movieTitle.text = movie?.title
        movieReleaseDate.text = movie?.releaseDate
        movieGenre.text? = ""
        
        guard let genres = movie?.genres else { return }
        for genre in genres {
            if genres.index(where: { $0.id == genre.id} ) == 0 {
                movieGenre.text?.append("\(String(describing: genre.name!))")
            } else{
                movieGenre.text?.append("   \(String(describing: genre.name!))")
            }
        }
        
        DispatchQueue.main.async { self.getMoviePosterImage() }
    }
    
    private func getMoviePosterImage(){
        if let imageString = movie?.imagePoster {
            movieImageActivityIndicator.isHidden = false
            movieImageActivityIndicator.startAnimating()
            
            let movieImagePosterObservable = MANetwork().sendGETRequestResponseData(url: MANetwork.GET_MOVIE_IMAGE_POSTER + imageString)
            
            disposable = movieImagePosterObservable.subscribe(onNext: { [weak self](imagePosterData) in
                self?.movieImage.image = UIImage(data: imagePosterData)
            }, onError: { (error) in
                print(error)
            }, onCompleted: {
                self.movieImageActivityIndicator.stopAnimating()
                self.movieImageActivityIndicator.isHidden = true
            })
        }
    }
    
    override func prepareForReuse() {
        movieImage.image = nil
        movieReleaseDate.text = ""
        movieTitle.text = ""
        
        disposable?.dispose()
    }

}
