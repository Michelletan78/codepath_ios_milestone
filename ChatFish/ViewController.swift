//
//  ViewController.swift
//  ChatFish
//
//  Created by apple on 25/10/2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage


class ViewController: UIViewController {
    
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign In"
        
        img.layer.cornerRadius = 8
    }
    @IBAction func signInAction(_ sender: Any) {
        if emailTF.text == ""{
            errorWithMsg(message: "Please give email address")
        }else if passwordTF.text == ""{
            errorWithMsg(message: "Please give password")
        }else{
            showIndicator()
            Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { authResult, error in
                if authResult != nil {
                    Helper.userId = Auth.auth().currentUser!.uid
                    UserDefaults.standard.set(Helper.userId, forKey: "userId")
                    UserDefaults.standard.set(true, forKey: "isloggedIn")
                    UserDefaults.standard.synchronize()
                    self.hideIndicator()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatList")
                    vc?.modalTransitionStyle = .flipHorizontal
                    vc?.modalPresentationStyle = .fullScreen
                    self.present(vc!, animated: true)
                } else {
                    self.hideIndicator()
                    self.errorWithMsg(message: error!.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

