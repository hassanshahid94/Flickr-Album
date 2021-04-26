//
//  PhotosTCell.swift
//  Flickr Album
//
//  Created by Hassan on 24.4.2021.
//

import UIKit
import SnapKit

class PhotosTCell: UITableViewCell {

    //MARK:- Variables for Outlets/UI
    var vwBackground: UIView!
    var imgAlbum: UIImageView!
    var lblTitle: UILabel!
    
    //MARK:- Load
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        //adding background view to the contentview
        vwBackground = UIView()
        vwBackground.layer.cornerRadius = 10
        vwBackground.dropShadow(scale: false)
        contentView.addSubview(vwBackground)
        vwBackground.snp.makeConstraints { (make) -> Void in
            
            make.top.equalTo(contentView.snp.top).inset(10)
            make.leading.equalTo(contentView.snp.leading).inset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
        }
        
        //Adding label to the background view
        lblTitle = UILabel()
        lblTitle.font = UIFont.FlickAlbum_description
        lblTitle.textAlignment = .center
        lblTitle.numberOfLines = 0
        vwBackground.addSubview(lblTitle)
        
        lblTitle.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.bottom.equalTo(vwBackground.snp.bottom).inset(10)
        }
        
        //adding imageview to the background view
        imgAlbum = UIImageView()
        imgAlbum.layer.cornerRadius = 10
        imgAlbum.contentMode = .scaleAspectFill
        imgAlbum.clipsToBounds = true
        vwBackground.addSubview(imgAlbum)
        imgAlbum.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(200)
            make.top.equalTo(vwBackground.snp.top).inset(10)
            make.leading.equalTo(vwBackground.snp.leading).inset(10)
            make.trailing.equalTo(vwBackground.snp.trailing).inset(10)
            make.bottom.equalTo(lblTitle.snp.top).inset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
