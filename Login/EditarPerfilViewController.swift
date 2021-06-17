//
//  EditarPerfilViewController.swift
//  Login
//
//  Created by marco rodriguez on 31/05/21.
//

import UIKit
import Firebase
import FirebaseStorage

class EditarPerfilViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var idImage: String?
    let db = Firestore.firestore()
    
    @IBOutlet weak var nombreEditarTF: UITextField!
    @IBOutlet weak var imagenPerfil: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func tomarFotoButton(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType = .savedPhotosAlbum
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func GuardarPerfilButton(_ sender: UIButton) {
        //MARK: Subir Imagen
        //convertir la imagen en datos
        guard let image = imagenPerfil.image, let datosImagen = image.jpegData(compressionQuality: 1.0) else {
            print("error al comvertir imagen a datos")
            return
        }
        //asignar un id a los datos
        let imageName = UUID().uuidString
        idImage = imageName
        
        let imageReference = Storage.storage()
            .reference()
            .child("imagenes")
            .child(imageName)
        
        //Subir los datos a Firebase
        imageReference.putData(datosImagen, metadata: nil) { (metaData, err) in
            if let e = err {
                print("Error al subir imagen \(e.localizedDescription)")
            }
            
            imageReference.downloadURL { (url, error) in
                if let err = error {
                    print("Error al subir imagen en imageReference2 \(err.localizedDescription)")
                    return
                }
                
                guard let url = url else {
                    print("Error al crear url de la imagen")
                    return
                }
                guard let email = Auth.auth().currentUser?.email else { return }
                let dataRefernce = Firestore.firestore().collection("imagenes").document(email)
                let documentIDImg = dataRefernce.documentID
                
                let urlString = url.absoluteURL
                
                let dataSend = ["id": documentIDImg, "url": urlString] as [String : Any]
                
                dataRefernce.setData(dataSend) { (error) in
                    if let err = error {
                        print("Error al mandar los datos de la imagen \(err.localizedDescription)")
                        return
                    }else{
                        print("imagen guardada en FireStore")
                    }
                    
                }
            }
            
        }
        
        //MARK: Actualizar nombre
        
        guard let email = Auth.auth().currentUser?.email else { return }
        
        if let name = nombreEditarTF.text{
            db.collection("usuarios").document(email).setData(["userName": name ])
        }
        
        navigationController?.popViewController(animated: true)
        print("Perfil Actualizado!")
    }
    
    
    //Que vamos a hacer cuando el usuario selecciona una imagen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSeleccionada = info [UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            imagenPerfil.image = imagenSeleccionada
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

