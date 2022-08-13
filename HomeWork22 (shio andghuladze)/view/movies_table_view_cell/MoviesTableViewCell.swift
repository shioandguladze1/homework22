//
//  MoviesTableViewCell.swift
//  HomeWork22 (shio andghuladze)
//
//  Created by shio andghuladze on 13.08.22.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(title: String, posterURL: String){
        
        titleLabel.text = title
        getImage(imageUrl: posterURL) { r in
            
            parseResult(result: r) { (image: UIImage) in
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            }
            
        }
        
    }
    
}
