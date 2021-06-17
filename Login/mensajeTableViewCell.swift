//
//  mensajeTableViewCell.swift
//  Login
//
//  Created by Ramiro y Jennifer on 13/06/21.
//

import UIKit

class mensajeTableViewCell: UITableViewCell {

    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var mensajeLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backView.layer.masksToBounds = false
        backView.layer.cornerRadius = 9
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowOffset = .zero
        backView.layer.shadowRadius = 5
    }
    
}
