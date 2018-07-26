//
//  MAMoviesListController.swift
//  TheMovieApp
//
//  Created by Lucas Veras Aguiar Cardoso on 15/07/18.
//  Copyright © 2018 Lucas Veras Aguiar Cardoso. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MAMoviesListController: UITableViewController {
    
    private let disposedBag = DisposeBag()
    
    private var upcomingMoviesFiltered:[MAMovie] = []
    private var upcomingMovies:[MAMovie] = []
    private var numberOfPages = 1
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Próximos lançamentos"
        
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.prefetchDataSource = self

        addActivityIndicatorTableViewFooter()
        getUpcomingMovies()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil) // Search Controller
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.rx.text.orEmpty.subscribe(onNext: { [unowned self] query in
            self.upcomingMoviesFiltered = query.isEmpty ? self.upcomingMovies : self.upcomingMovies.filter { $0.title?.lowercased().range(of: query.lowercased()) != nil }
            self.reloadTableView()
        }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [unowned self] (_) in
                self.upcomingMoviesFiltered = self.upcomingMovies
                self.reloadTableView()
        }).disposed(by: disposeBag)
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }

    private func getUpcomingMovies(){
        let upcomingMoviesObservable = MANetwork().sendGETRequestResponseJSON(url: MANetwork.UPCOMING_MOVIE_LIST_PAGE + String(describing: numberOfPages), responseType: MAMovie.self)
        
        upcomingMoviesObservable.subscribe(onNext: { [weak self](upcomingMovies) in
            self?.upcomingMovies.append(contentsOf: upcomingMovies)
            self?.upcomingMoviesFiltered = (self?.upcomingMovies)!
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            self.reloadTableView()
        }).disposed(by: disposedBag)
    }
    
    private func addActivityIndicatorTableViewFooter(){
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44)
        tableView.tableFooterView = spinner;
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    private func getOneMoreUpcomingMoviePage(){
        numberOfPages += 1
        getUpcomingMovies()
    }
    
    // MARK: Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MAMovieDetailController {
            let indexPath = (sender as! IndexPath)
            controller.movieToDetail = upcomingMoviesFiltered[indexPath.row]
            controller.moviePosterImage = (tableView.cellForRow(at: indexPath) as! MAMovieListCell).movieImage.image
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMoviesFiltered.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieListCell", for: indexPath) as! MAMovieListCell

        cell.movie = upcomingMoviesFiltered[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMovieDetail", sender: indexPath)
    }

}

extension MAMoviesListController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            getOneMoreUpcomingMoviePage()
        }
    }
}

private extension MAMoviesListController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= upcomingMovies.count - 1
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
