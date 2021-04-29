//
//  FiltersCCell.swift
//  Flickr Album
//
//  Created by Hassan on 29.4.2021.
//

import UIKit
import SnapKit

class FiltersCCell: UICollectionViewCell {
    
    var btnFilter: UIButton!
    
    //MARK:- Load
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //adding background view to the contentview
        btnFilter = UIButton()
        btnFilter.setTitle("Button", for: .normal)
        btnFilter.backgroundColor = UIColor.FlickrAlbum_theme
        contentView.addSubview(btnFilter)
        btnFilter.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp.top).inset(10)
            make.leading.equalTo(contentView.snp.leading).inset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
        }
    }
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
}
