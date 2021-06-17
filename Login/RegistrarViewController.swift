//
//  RegistrarViewController.swift
//  Login
//
//  Created by marco rodriguez on 25/05/21.
//

import UIKit
import Firebase

class RegistrarViewController: UIViewController {
    @IBOutlet weak var correoTF: UITextField!
    @IBOutlet weak var contraseñaTF: UITextField!
    @IBOutlet weak var nombreTF: UITextField!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func alertaMensaje(msj: String) {
        let alerta = UIAlertController(title: "ERROR", message: msj, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
        present(alerta, animated: true, completion: nil)
    }
    

    @IBAction func registrarButton(_ sender: UIButton) {
        if let email = correoTF.text, let password = contraseñaTF.text, let nombre = nombreTF.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                self.db.collection("usuarios").document(email).setData(["nombre": nombre])
                if let e = error {
                    print("Error al crear usuario \(e.localizedDescription)")
                    if e.localizedDescription == "The email address is already in use by another account." {
                        self.alertaMensaje(msj: "Ese correo ya esta en uso, favor de crear otro")
                    } else if e.localizedDescription == "The email address is badly formatted." {
                        self.alertaMensaje(msj: "Verifica el formato de tu email")
                    } else if e.localizedDescription == "The password must be 6 characters long or more." {
                        self.alertaMensaje(msj: "Tu contraseña debe de ser de 6 caracteres o mas")
                    }
                    
                } else {
                    //Navegar al siguiente VC
                    self.performSegue(withIdentifier: "registroInicio", sender: self)
                }
                
            }
        }
        
    }
    

}
