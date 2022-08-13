//
//  MovieDetailsViewController.swift
//  HomeWork22 (shio andghuladze)
//
//  Created by shio andghuladze on 13.08.22.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var posterImageview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ratingLabel: UILabel!
    var movie: Movie?
    @IBOutlet weak var ratingSwiper: UISlider!
    var sliderValue: Float = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp(){
        if let movie = movie {
            titleLabel.text = movie.name
            descriptionTextView.text = movie.overview
            ratingLabel.text = String(sliderValue)
            getImage(imageUrl: imagePath + movie.poster_path) { r in
                
                parseResult(result: r) { (image: UIImage) in
                    DispatchQueue.main.async {
                        self.posterImageview.image = image
                    }
                }
                
            }
        }

    }

    @IBAction func onSwipe(_ sender: UISlider) {
        ratingLabel.text = String(sender.value)
        sliderValue = sender.value
    }
    
    @IBAction func onRate(_ sender: Any) {
        guard let movie = movie else {
            return
        }
        
        fetchData(url: baseUrl + createGuestSessionPath, dataType: GuestSession.self) { r in
        
            parseResult(result: r) { (session: GuestSession) in
                
                let query = [apiKeyQueryItem, URLQueryItem(name: "guest_session_id", value: session.guest_session_id)]
                let body = ["value": self.sliderValue]
                postData(url: baseUrl + tvShowDetailsPath + String(movie.id) + setTvShowRatingPath, queryItems: query, body: body) { r in
                    parseResult(result: r) { (data: Data?) in
                        print(data?.toString() ?? "")
                    }
                }
                
            }
            
        }
    }
}
