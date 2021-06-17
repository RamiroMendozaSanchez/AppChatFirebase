//
//  LoginViewController.swift
//  Login
//
//  Created by marco rodriguez on 25/05/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var correoTF: UITextField!
    @IBOutlet weak var contraseñaTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func alertaMensaje(msj: String) {
        let alerta = UIAlertController(title: "ERROR", message: msj, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
        present(alerta, animated: true, completion: nil)
    }


    @IBAction func loginButton(_ sender: UIButton) {
        
        
        if let email = correoTF.text, let password = contraseñaTF.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
             
                if let e = error {
                    print(e.localizedDescription)
                    switch e.localizedDescription {
                        case "There is no user record corresponding to this identifier. The user may have been deleted.":
                            self.alertaMensaje(msj: "Este usuario no está registrado o ha sido borrado")
                        case "The password is invalid or the user does not have a password.":
                            self.alertaMensaje(msj: "La contrseña es incorrecta.")
                        case "The email address is badly formatted.":
                            self.alertaMensaje(msj: "El formato del correo es incorrecto")
                    default:
                        self.alertaMensaje(msj: "El correo y contraaseña no coinciden")
                    }
                } else {
                    //NAvegar al inicio
                    self.performSegue(withIdentifier: "loginInicio", sender: self)
                }
                
            }
        }
        
    }
    

}
