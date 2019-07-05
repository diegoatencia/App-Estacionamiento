import UIKit
import FirebaseAuth

class Inicio: UIViewController {

    //MARK: OUTLETS
    
    
    
    //MARK: FUNCIONES
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Salir", style: .plain, target: self, action: #selector(self.backButtonTapped))
    }

    //Función cuando se toca el boton 'Salir'.
    @objc func backButtonTapped() {
        let alert = UIAlertController(title: "Cerrar Sesión", message: "¿Deseas salir?", preferredStyle: .alert)
        let aceptar = UIAlertAction(title: "Aceptar", style: .default){ (_) in
            try! Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        alert.addAction(cancelar)
        alert.addAction(aceptar)
        present(alert, animated: true, completion: nil)
    }

}
