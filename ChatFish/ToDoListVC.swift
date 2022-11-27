//
//  ToDoListVC.swift
//  ChatFish
//
//  Created by apple on 25/10/2022.
//

import UIKit
import FirebaseDatabase
import IQKeyboardManagerSwift

class ToDoListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var todoTable: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var todoTF: UITextField!
    var todoList:[NSDictionary] = []
    
    let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "To Do"
        getTodoData()
        addLable()
        todoTable.delegate = self
        todoTable.dataSource = self
    
    }
    func addLable(){
        lbl.center = self.view.center
        lbl.textAlignment = .center
        lbl.text = "No record found"
        self.view.addSubview(lbl)
        lbl.isHidden = true
        
    }
    func containsSwearWord(text: String, swearWords: [String]) -> Bool {
        return swearWords
            .reduce(false) { $0 || text.contains($1.lowercased()) }
    }
    @IBAction func addAction(_ sender: Any) {
        if todoTF.text == ""{
            errorWithMsg(message: "Type a messsage")
        }else if ((todoTF.text?.trimmingCharacters(in: .whitespaces).isEmpty) == nil){
            errorWithMsg(message: "Type a messsage")
        }else if ((todoTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) == nil){
            errorWithMsg(message: "Type a messsage")
        }else if containsSwearWord(text: todoTF.text!.lowercased(), swearWords: Helper.abuseWords) {
            errorWithMsg(message: "Can't send abusive message")
        }else{
            let connectedRef = Database.database().reference(withPath: ".info/connected")
            connectedRef.observeSingleEvent(of:.value, with: { [self] snapshot in
                if snapshot.value as? Bool ?? false {
                    
                    let nowDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss Z"
                    let finaldate = dateFormatter.string(from: nowDate)
                    let senderId = Helper.userDataDic["id"] as? String ?? ""
                    let autoId = Helper.dbRef.childByAutoId().key!
                    let message = self.todoTF.text?.condensingWhitespace()
                    let lastMsg = ["date":finaldate,"id":"\(autoId)","from":Helper.userId,"msg":message,"time":"\(Date().millisecondsSince1970)"]
                    
                    Helper.dbRef.child("todo").child(senderId).child(autoId).setValue(lastMsg)
                    self.todoTF.text = ""
                } else {
                    errorWithTitleMsg(title: "no_network", message: "please_connect_to_internet")
                    return
                }
            })
        }
    }
    
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoTableCell", for: indexPath) as! todoTableCell
        cell.todoLbl.text = todoList[indexPath.row]["msg"] as? String ?? ""
        
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
          let row = indexPath.row
  
          let delete = UIContextualAction(style: .destructive, title: "Delete") { (action,view,completionHandler) in
              let id = self.todoList[indexPath.row]["id"] as? String ?? ""
              Helper.dbRef.child("todo").child(Helper.userId).child(id).removeValue()
              self.getTodoData()
          }
          return  UISwipeActionsConfiguration(actions: [delete])
      }
    
    func getTodoData(){
        self.showIndicator()
        todoList.removeAll()
        let ref = Helper.dbRef.child("todo").child(Helper.userId)
            ref.observe( .childAdded) { snapShot in
            guard snapShot.exists() else{
                return
            }
            let dict = snapShot.value as! NSDictionary
            self.todoList.append(dict)
                if self.todoList == []{
                    self.lbl.isHidden = false
                }else{
                    self.lbl.isHidden = true
                }
            self.todoTable.reloadData()
            self.hideIndicator()
        }
        ref.observeSingleEvent(of:.value) { snapShot in
            guard snapShot.exists() else{
                self.lbl.isHidden = false
                self.hideIndicator()
                return
            }
            
        }
        
    }

    
}
