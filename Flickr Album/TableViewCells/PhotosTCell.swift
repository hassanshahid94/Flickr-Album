//
//  PhotosTCell.swift
//  Flickr Album
//
//  Created by Hassan on 24.4.2021.
//

import UIKit

class PhotosTCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgAlbum: UIImageView!
    @IBOutlet weak var vwBackground: UIView!
    
    var data : FlickrAlbumPhoto? {
        didSet {
            lblTitle.text = data?.id
            
            imgAlbum.sd_setImage(with: URL(string: "\(Constants.imgURL)\(data?.server ?? "")/\(String(describing: data?.id ?? ""))_\(data?.secret ?? "").jpg"), placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
    //MARK:- Load
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Functions
    func initViews() {
        vwBackground.layer.cornerRadius = 10
        vwBackground.dropShadow(scale: false)
        imgAlbum.layer.cornerRadius = 10
    }

}
