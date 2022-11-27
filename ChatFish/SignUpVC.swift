//
//  SignUpVC.swift
//  ChatFish
//
//  Created by apple on 25/10/2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class SignUpVC: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signInAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    

    @IBAction func signUpAction(_ sender: Any) {
        if nameTF.text == ""{
            errorWithMsg(message: "Please give name")
        }else if emailTF.text == "" {
            errorWithMsg(message: "Please give email")
        }else if passwordTF.text == "" {
            errorWithMsg(message: "Please give password")
        }else if confirmPassword.text == "" {
            errorWithMsg(message: "Please enter Confirm Password")
        }else{
            Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!) { [self] authResult, error in
                guard authResult != nil, error == nil else {
                    hideIndicator()
                    errorWithMsg(message: (error?.localizedDescription)!)
                    return
                }
                
                Helper.userId = Auth.auth().currentUser!.uid
                let date = NSDate.now
                let para = ["createdOn":date,"email":self.emailTF.text!,"fullName":self.nameTF.text!,"id":Helper.userId] as [String : Any?]
                Helper.firRef.collection("Users").document(Helper.userId).setData(para as [String : Any]){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        UserDefaults.standard.set(Helper.userId, forKey: "userId")
                        UserDefaults.standard.set(true, forKey: "isloggedIn")
                        UserDefaults.standard.synchronize()
                        self.hideIndicator()
                        
                        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatList")
                        vc?.modalPresentationStyle = .fullScreen
                        present(vc!, animated: true)
                    }
                }
            }
        }
        
    }
}
