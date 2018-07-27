//
//  MAMovieDetailController.swift
//  TheMovieApp
//
//  Created by Lucas Veras Aguiar Cardoso on 25/07/18.
//  Copyright © 2018 Lucas Veras Aguiar Cardoso. All rights reserved.
//

import UIKit

class MAMovieDetailController: UITableViewController {
    
    var movieToDetail: MAMovie?
    var moviePosterImage: UIImage?
    
    var genresString = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        
        setupGenresString()
    }
    
    private func setupGenresString(){
        guard let genres = movieToDetail?.genres else { return }
        for genre in genres {
            if genres.index(where: { $0.id == genre.id} ) == 0 {
                genresString.append("\(String(describing: genre.name!))")
            } else{
                genresString.append("   \(String(describing: genre.name!))")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 350 : UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MAConstants.ReuseIdentifier.moviePosterCell, for: indexPath) as! MAMovieDetailPosterCell
            
            cell.moviePosterImageView.image = moviePosterImage
            cell.movieTitle.text = movieToDetail?.title
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MAConstants.ReuseIdentifier.movieSynopsis, for: indexPath)
            
            cell.textLabel?.text = NSLocalizedString("GENRES", comment: "")
            cell.detailTextLabel?.text = genresString
            
            return cell
            
        case 2, 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: MAConstants.ReuseIdentifier.movieSynopsis, for: indexPath)
            
            cell.textLabel?.text = indexPath.row == 2 ? NSLocalizedString("MOVIE_OVERVIEW", comment: "") : NSLocalizedString("RELEASE_DATE", comment: "")
            cell.detailTextLabel?.text = indexPath.row == 2 ? movieToDetail?.overview : movieToDetail?.releaseDate
            
            return cell
        default:
            return UITableViewCell()
        }
    }

}
