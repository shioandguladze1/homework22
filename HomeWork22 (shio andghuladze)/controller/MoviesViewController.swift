//
//  MoviesViewController.swift
//  HomeWork22 (shio andghuladze)
//
//  Created by shio andghuladze on 13.08.22.
//

import UIKit

class MoviesViewController: UIViewController {
    @IBOutlet weak var moviesTableView: UITableView!
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUptableview()
    }
    
    private func setUptableview(){
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.register(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesTableViewCell")
        let url = baseUrl + tvShowsPath
        fetchData(url: url, dataType: Movies.self) { r in
            
            parseResult(result: r) { (movie: Movies) in
                DispatchQueue.main.sync {
                    self.movies = movie.results
                    self.moviesTableView.reloadData()
                }
            }
            
        }
    }

}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as? MoviesTableViewCell{
            
            let movie = movies[indexPath.row]
            cell.setUp(title: movie.name, posterURL: imagePath + movie.poster_path)
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController{
            controller.movie = movie
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
