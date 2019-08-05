//
//  SocialMediaAccountCell.swift
//  Gymmie
//
//  Created by Blake Rogers on 9/8/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit
protocol SocialDelegate{
    func attachFB()
    func attachTwitter()
    func attachIG()
}
class SocialMediaAccountCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var delegate: SocialDelegate?
    @IBAction func attachFaceBook(_ sender: UIButton){
        delegate?.attachFB()
    }
    @IBAction func attachTwitter(_ sender:UIButton){
        delegate?.attachTwitter()
    }
    @IBAction func attachInstagram(_ sender: UIButton){
        delegate?.attachIG()
    }
}
