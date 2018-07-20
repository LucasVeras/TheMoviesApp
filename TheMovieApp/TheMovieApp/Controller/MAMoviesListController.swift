//
//  MAMoviesListController.swift
//  TheMovieApp
//
//  Created by Lucas Veras Aguiar Cardoso on 15/07/18.
//  Copyright © 2018 Lucas Veras Aguiar Cardoso. All rights reserved.
//

import UIKit
import RxSwift

class MAMoviesListController: UITableViewController {
    
    private let disposedBag = DisposeBag()
    
    private var upcomingMovies:[MAMovie] = []
    private var numberOfPages = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Próximos lançamentos"
        
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableViewAutomaticDimension

        addActivityIndicatorTableViewFooter()
        getUpcomingMovies()
    }

    private func getUpcomingMovies(){
        let upcomingMoviesObservable = MANetwork().sendGETRequestResponseJSON(url: MANetwork.UPCOMING_MOVIE_LIST_PAGE + String(describing: numberOfPages), responseType: MAMovie.self)
        
        upcomingMoviesObservable.subscribe(onNext: { [weak self](upcomingMovies) in
            self?.upcomingMovies.append(contentsOf: upcomingMovies)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            self.tableView.reloadData()
        }).disposed(by: disposedBag)
    }
    
    private func addActivityIndicatorTableViewFooter(){
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44)
        tableView.tableFooterView = spinner;
    }
    
    private func getOneMoreUpcomingMoviePage(){
        numberOfPages += 1
        getUpcomingMovies()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieListCell", for: indexPath) as! MAMovieListCell
 
        cell.movie = upcomingMovies[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == upcomingMovies.count - 1) {
            getOneMoreUpcomingMoviePage()
        }
    }

}
