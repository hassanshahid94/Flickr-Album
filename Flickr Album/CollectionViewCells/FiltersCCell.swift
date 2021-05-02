//
//  FiltersCCell.swift
//  Flickr Album
//
//  Created by Hassan on 29.4.2021.
//

import UIKit
import SnapKit

class FiltersCCell: UICollectionViewCell {
    
    //MARK:- Variables for Outlets/UI
    var vwBackground: UIView!
    var lblFilter: UILabel!
    
    //MARK:- Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        //adding background view to the contentview
        vwBackground = UIView()
        vwBackground.layer.cornerRadius = 10
        vwBackground.layer.borderWidth = 1
        vwBackground.layer.borderColor = UIColor.FlickrAlbum_theme.cgColor
        //vwBackground.dropShadow()
        contentView.addSubview(vwBackground)
        vwBackground.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp.top).inset(10)
            make.leading.equalTo(contentView.snp.leading).inset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
        }
        //adding background view to the contentview
        lblFilter = UILabel()
        //lblFilter.text = "Label"
        lblFilter.font = UIFont.FlickAlbum_description
        lblFilter.textAlignment = .center
        lblFilter.numberOfLines = 0
        vwBackground.addSubview(lblFilter)
        lblFilter.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(vwBackground.snp.top).inset(0)
            make.leading.equalTo(vwBackground.snp.leading).inset(0)
            make.trailing.equalTo(vwBackground.snp.trailing).inset(0)
            make.bottom.equalTo(vwBackground.snp.bottom).inset(0)
        }
    }
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
}
