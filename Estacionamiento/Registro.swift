import UIKit
import FirebaseAuth
import FirebaseDatabase

class Registro: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var contraseña: UITextField!
    @IBOutlet weak var confirmarContraseña: UITextField!
    
    //MARK: VARIABLES
    var ref: DatabaseReference!
    
    //MARK: FUNCIONES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        //Se agrega tap para ocultar teclado
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(("ocultarTeclado")))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func registrar(_ sender: UIButton) {
        
        if correo.text != "" && contraseña.text != "" && confirmarContraseña.text != "" {
            if contraseña.text == confirmarContraseña.text {
                guard let email = correo.text else { return }
                guard let pass = contraseña.text else { return }
                Auth.auth().createUser(withEmail: email, password: pass){ (user, error) in
                    if user != nil {
                        print("Usuario creado")
                        self.guardarUsuario()
                    } else {
                        if let error = error?.localizedDescription {
                            print("Error en firebase", error)
                        } else {
                            print("Error de codigo")
                        }
                    }
                }
            } else {
                let alerta = UIAlertController(title: "Atención", message: "Las contraseñas ingresadas no coinciden", preferredStyle: .alert)
                let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                alerta.addAction(aceptar)
                present(alerta, animated: true, completion: nil)
            }
        } else {
            let alerta = UIAlertController(title: "Atención", message: "Ingrese correo electrónico y contraseñas", preferredStyle: .alert)
            let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alerta.addAction(aceptar)
            present(alerta, animated: true, completion: nil)
        }
    }
    
    func guardarUsuario(){
        //Guardar en Firebase Database.
        guard let id = Auth.auth().currentUser?.uid else { return }
        guard let email = Auth.auth().currentUser?.email else { return }
        let campos = ["correo": email, "idUser": id]
        ref.child("users").child(id).setValue(campos)
        dismiss(animated: true, completion: nil)
    }
    
    //Función para ocultar teclado en cualquier parte de la vista.
    @objc func ocultarTeclado(){
        self.view.endEditing(true)
    }
    
    @IBAction func cancelar(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
 
}
