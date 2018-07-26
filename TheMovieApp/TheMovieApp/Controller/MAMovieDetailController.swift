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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
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
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "moviePosterCell", for: indexPath) as! MAMovieDetailPosterCell
            
            cell.moviePosterImageView.image = moviePosterImage
            cell.movieTitle.text = movieToDetail?.title
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieSynopsis", for: indexPath)
            
            cell.textLabel?.text = indexPath.row == 2 ? "Visão geral do filme:" : "Data de lançamento:"
            cell.detailTextLabel?.text = indexPath.row == 2 ? movieToDetail?.overview : movieToDetail?.releaseDate
            
            return cell
        }
    }

}
