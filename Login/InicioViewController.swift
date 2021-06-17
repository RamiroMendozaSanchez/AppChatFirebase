//
//  InicioViewController.swift
//  Login
//
//  Created by marco rodriguez on 26/05/21.
//

import UIKit
import Firebase

class InicioViewController: UIViewController {
    
    var chats = [Mensaje]()
    
    //Agregar la referencia a la BD Firestore
    let db = Firestore.firestore()
    

    @IBOutlet weak var mensajeEnviarTF: UITextField!
    @IBOutlet weak var tablaChats: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "mensajeTableViewCell", bundle: nil)
        
        tablaChats.register(nib, forCellReuseIdentifier: "celdaMensaje")
        //ocultar el boton de regresar
        navigationItem.hidesBackButton = true
        
        cargarMensajes()
        
        if let email = Auth.auth().currentUser?.email {
            let defaults = UserDefaults.standard
            defaults.set(email, forKey: "email")
            defaults.synchronize()
        }
    }
    
    func cargarMensajes(){
        db.collection("mensajes")
            .order(by: "fechaCreacion")
            .addSnapshotListener() { (querySnapshot, err) in
                //Vaciar arreglo de chats
                self.chats = []
                
            if let e = err {
                print("Error al obtener los chats: \(e.localizedDescription)")
            } else {
                if let snapshotDocumentos = querySnapshot?.documents {
                    for document in snapshotDocumentos {
                        //crear mi objeto mensaje
                        let datos = document.data()
                        print(datos)
                        // Sacar los parametros p obj Mensaje
                        guard let remitenteFS = datos["remitente"] as? String else { return }
                        guard let mensajeFS = datos["mensaje"] as? String else { return }
                        
                        let nuevoMensaje = Mensaje(remitente: remitenteFS, cuerpoMsj: mensajeFS)
                        
                        self.chats.append(nuevoMensaje)
                        
                        DispatchQueue.main.async {
                            self.tablaChats.reloadData()
                        }
                       
                     }
                }
                
            }
        }
        
        
    }
    
    
    
    @IBAction func enviarButton(_ sender: UIButton) {
        guard let correo = Auth.auth().currentUser?.email else { return }
        db.collection("usuarios").document(correo).getDocument{
            (docuumentSnapshot, error) in
            if let documento = docuumentSnapshot, error == nil{
                if let usuario = documento.get("nombre"){
                    if let mensaje = self.mensajeEnviarTF.text {
                        self.db.collection("mensajes").addDocument(data: [
                            "remitente": usuario,
                            "mensaje": mensaje,
                            "fechaCreacion": Date().timeIntervalSince1970
                        ]) { (error) in
                            //si hubo errro
                            if let e = error {
                                print("Error al guardar en Firestore \(e.localizedDescription)")
                            } else {
                                //Se realizo la insersion a firestore
                                print("Se guardo la info en firestore")
                                self.mensajeEnviarTF.text = ""
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    @IBAction func salirButton(_ sender: UIBarButtonItem) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.synchronize()
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
        print("Cerro sesion correctamente!")
        navigationController?.popToRootViewController(animated: true)
    } catch let error as NSError {
        print ("Error al cerrar sesion\(error.localizedDescription)")
    }
        
        
      
    }
    
    

}

//MARK: - Uitable View Methods
extension InicioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaChats.dequeueReusableCell(withIdentifier: "celdaMensaje", for: indexPath) as! mensajeTableViewCell
        celda.mensajeLabel.text = chats[indexPath.row].cuerpoMsj
        celda.nombreLabel.text = chats[indexPath.row].remitente
        return celda
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
