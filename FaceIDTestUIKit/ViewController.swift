//
//  ViewController.swift
//  FaceIDTestUIKit
//
//  Created by Brandon Suarez on 12/21/23.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

extension ViewController {
    func setupViews() {
        view.backgroundColor = .white
        title = "Face ID Test"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(button)
        
        setupButton()
    }
    
    func setupButton() {
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.setTitle("Authorize", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        let context = LAContext()
        var error: NSError? = nil
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please Authorize with Touch ID!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [unowned self] success, error in
                DispatchQueue.main.async {
                    guard success, error == nil else {
                        // Failed
                        let alertController = UIAlertController(title: "Failed To Authenticate", message: "Please try again", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self.present(alertController, animated: true)
                        return
                    }
                    // Show Other Screen
                    // Success
                    let viewController = UIViewController()
                    viewController.modalPresentationStyle = .popover
                    viewController.view.backgroundColor = .systemBlue
                    viewController.title = "Welcome"
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        } else {
            let alertController = UIAlertController(title: "Not Available", message: "You can't use this feature", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
    }
}

