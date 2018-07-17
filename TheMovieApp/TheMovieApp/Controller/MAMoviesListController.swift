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
    
    let disposedBag = DisposeBag()
    
    var upcomingMovies:[MAMovie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Próximos lançamentos"

        getUpcomingMovies()
    }

    private func getUpcomingMovies(){
        let upcomingMoviesObservable = MANetwork().sendRequest(url: .UPCOMING_MOVIE_LIST, responseType: MAMovie.self)
        
        upcomingMoviesObservable.subscribe(onNext: { [weak self](upcomingMovies) in
            self?.upcomingMovies = upcomingMovies
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            self.tableView.reloadData()
        }).disposed(by: disposedBag)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)

        cell.textLabel?.text = upcomingMovies[indexPath.row].title

        return cell
    }
}
