//
//  ViewController.swift
//  Login
//
//  Created by marco rodriguez on 19/05/21.
//

import UIKit
import CLTypingLabel

class ViewController: UIViewController {

    @IBOutlet weak var mensajeBienvendiaLebel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mensajeBienvendiaLebel.charInterval = 0.05
        
        mensajeBienvendiaLebel.text = "Bienvenidos al chat de ARPAN, inicia sesión con tu correo empresarial."
    
        let defaults = UserDefaults.standard

        if let email = defaults.value(forKey: "email") as? String {
            //Utilizar un segue hasta inicio Chat
            performSegue(withIdentifier: "logueado", sender: self)
        }
    }


}

