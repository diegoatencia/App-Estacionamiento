import UIKit
import FirebaseAuth

class IniciarSesion: UIViewController {

    //MARK: OUTLETS.
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var botonIniciarSesion: UIButton!
    @IBOutlet weak var botonRegistrarse: UIButton!
    
    //MARK: FUNCIONES.
    //MARK: ViewDidLoad().
    override func viewDidLoad() {
        super.viewDidLoad()
        
        correo.text = ""
        password.text = ""
        
        //Se agrega tap para ocultar teclado
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(("ocultarTeclado")))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: ViewDidAppear().
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        correo.text = ""
        password.text = ""
        
        sesionActiva()
        
        botonIniciarSesion.layer.cornerRadius = 10
        botonRegistrarse.layer.cornerRadius = 10
    }
    
    //Funciones cuando se toca el botón 'Iniciar Sesión'.
    @IBAction func ingresar(_ sender: UIButton) {
        if correo.text != "" && password.text != "" {
            guard let email = correo.text else { return }
            guard let contraseña = password.text else { return }
            inicioSesion(correo: email, pass: contraseña)
        } else {
            let alerta = UIAlertController(title: "Atención", message: "Ingrese correo electrónico y contraseña.", preferredStyle: .alert)
            let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alerta.addAction(aceptar)
            present(alerta, animated: true, completion: nil)
        }
    }
    
    //Inicio sesion con mail y contraseña ingresada, autenticando en Firebase.
    /* Firebase verifica primero que exista una cuenta registrada con ese mail y si se ingresa un mail y su correspondiente contraseña, se ingresa al sistema. */
    func inicioSesion(correo: String, pass: String){
        Auth.auth().signIn(withEmail: correo, password: pass){ (user, error) in
            if user != nil {
                print("Entró")
                self.performSegue(withIdentifier: "entrar", sender: self)
            } else {
                if let error = error?.localizedDescription {
                    print("Error en Firebase", error)
                } else {
                    print("Error en el código")
                }
                
                let alerta = UIAlertController(title: "Atención", message: "Se produjo un error al iniciar sesión. Verifique que el correo electrónico y la contraseña sean correctas.", preferredStyle: .alert)
                let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                alerta.addAction(aceptar)
                self.present(alerta, animated: true, completion: nil)
            }
        }
    }
    
    //Comprueba si la sesion estaba iniciada.
    func sesionActiva(){
        Auth.auth().addStateDidChangeListener { (auth, error) in
            if error == nil {
                print("No estamos logueados")
            } else {
                print("Si estamos logueados")
                self.performSegue(withIdentifier: "entrar", sender: self)
            }
        }
    }
    
    //Función para ocultar teclado en cualquier parte de la vista.
    @objc func ocultarTeclado(){
        self.view.endEditing(true)
    }
    
    //Funciones cuando se toca el botón 'Olvidé mi contraseña'.
    /*Envía mail al correo ingresado con un link. Dentro de ese link, se realiza el cambio de contraseña.*/
    @IBAction func olvidarContraseña(_ sender: UIButton) {
        if correo.text != "" {
            guard let mail = correo.text else { return }
            Auth.auth().sendPasswordReset(withEmail: mail) { (error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error al enviar mail", error.localizedDescription)
                    } else {
                        let alerta = UIAlertController(title: "Verificación", message: "Se le ha enviado un correo electrónico a su cuenta de correo. Por favor, verifíquelo y siga las instrucciones.", preferredStyle: .alert)
                        let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                        alerta.addAction(aceptar)
                        self.present(alerta, animated: true, completion: nil)
                        print("Se envió el mail correctamente")
                    }
                }
            }
        } else {
            let alerta = UIAlertController(title: "Atención", message: "Ingrese correo electrónico asociado a su cuenta e intente nuevamente.", preferredStyle: .alert)
            let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alerta.addAction(aceptar)
            present(alerta, animated: true, completion: nil)
        }
        
    }
    
}
