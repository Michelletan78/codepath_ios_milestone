//
//  ChattingVC.swift
//  ChatFish
//
//  Created by apple on 25/10/2022.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import IQKeyboardManagerSwift

class ChattingVC: UIViewController,UITextViewDelegate{
    
    @IBOutlet weak var sendBtn: UIButton!

    @IBOutlet weak var msgTV: TextViewAutoHeight!
    @IBOutlet weak var ChatingtableView: UITableView!
    @IBOutlet weak var tvBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var blockBtn: UIBarButtonItem!
    
    
    var msgsKeys = [String]()
    var msgsdataDic:[NSDictionary] = []
    
    var totalLines:CGFloat = 5
    var maxHeight:CGFloat?
    
    var fromId = ""
    var userUrl = ""
    var fromIdName = ""
    var fromBusiSideMenu = ""
    
    var blockId = ""
    var isBlock = false
    
        let loadingView = UIView()
        let spinner = UIActivityIndicatorView()
        let loadingLabel = UILabel()
    var showHide = "0"
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        checkBlock()
        // function calling
        getmsgsData()
        // valueChange()
        // getMsgKeys()
        setLoadingScreen()
        msgTV.inputAccessoryView = UIView()
        sendBtn.setTitle("Send", for: .normal)
        
        
        sendBtn.layer.cornerRadius = 5
        msgTV.maxHeight = 80
        msgTV.layer.cornerRadius = msgTV.frame.height/2
        // msgTV.layer.borderColor = UIColor.black.cgColor
        //msgTV.layer.borderWidth = 1
        msgTV.text = "Type a messsage"
        msgTV.tintColor = UIColor.black
        msgTV.textColor = UIColor.lightGray
        msgTV.delegate = self
        
        ChatingtableView.delegate = self
        ChatingtableView.dataSource = self
        ChatingtableView.rowHeight = UITableView.automaticDimension
        ChatingtableView.keyboardDismissMode = .onDrag
        
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ChattingVC.self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.tvBottomConstraint.constant = -keyboardSize.height + 8
        }
        
    }

    @objc func keyboardWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if msgTV.isFirstResponder {
                self.tvBottomConstraint.constant = keyboardSize.height + 8
                if msgsdataDic != []{
                    self.scrollToBottom()
                }
                
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type a messsage"
            textView.textColor = UIColor.lightGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let str = (textView.text as NSString? ?? "").replacingCharacters(in: range, with: text)
            if str == "" {
//                filesBtn.isHidden = false
            }else{
//                filesBtn.isHidden = true
            }
            return true
        }
 
    @IBAction func logOut(_ sender: Any) {
        do { try Auth.auth().signOut()
            UserDefaults.standard.setValue("", forKey: "userId")
            UserDefaults.standard.set(false, forKey: "isloggedIn")
            UserDefaults.standard.synchronize()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
            catch { print("already logged out") }
        
    }

    private func setLoadingScreen() {
        let width: CGFloat = 30
        let height: CGFloat = 30
        let x = (ChatingtableView.frame.width / 2) - (width / 2)
        let y = (ChatingtableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = " "
        self.title = "Connecting..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 160, height: 30)
        spinner.style = .medium
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        loadingView.addSubview(spinner)
       // loadingView.addSubview(loadingLabel)
        ChatingtableView.addSubview(loadingView)
        view.isUserInteractionEnabled = false

    }
    
    func getmsgsData(){
        let ref = Helper.dbRef.child("chat").child("Users").child(Helper.userId).child("chat").child(fromId)
            ref.observe( .childAdded) { snapShot in
            guard snapShot.exists() else{
                return
            }
            let dict = snapShot.value as! NSDictionary
            let msgId = dict["msg_key"] as? String ?? ""
                if dict["from"]as? String ?? "" == self.fromId{
                    Helper.dbRef.child("chat").child("Users").child(Helper.userId).child("lastmsg").child(self.fromId).updateChildValues(["read":"1"])
                }
           
            
            self.msgsdataDic.append(dict)
            self.updateTableView()
            self.removeLoadingScreen()
        }
        ref.observeSingleEvent(of:.value) { snapShot in
            guard snapShot.exists() else{
                self.removeLoadingScreen()
                return
            }
        }
        
    }
    
    func updateTableView(){
        let lastScrollOffset = ChatingtableView.contentOffset
        ChatingtableView.beginUpdates()
        ChatingtableView.insertRows(at: [IndexPath(row: msgsdataDic.count - 1, section: 0)], with: .automatic)
        ChatingtableView.endUpdates()
        ChatingtableView.setContentOffset(lastScrollOffset, animated: false)
        scrollToBottom()
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.msgsdataDic.count - 1, section: 0)
            self.ChatingtableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    

    private func removeLoadingScreen() {
        spinner.stopAnimating()
        spinner.isHidden = true
       // loadingLabel.isHidden = true
        self.title = fromIdName
        view.isUserInteractionEnabled = true
    }
    
    
    func containsSwearWord(text: String, swearWords: [String]) -> Bool {
        return swearWords
            .reduce(false) { $0 || text.contains($1.lowercased()) }
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
        if msgTV.text == "" || msgTV.text == "Type a messsage"{
            errorWithMsg(message: "Type a messsage")
        }else if msgTV.text.trimmingCharacters(in: .whitespaces).isEmpty{
            errorWithMsg(message: "Type a messsage")
        }else if msgTV.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            errorWithMsg(message: "Type a messsage")
        }else if containsSwearWord(text: msgTV.text!.lowercased(), swearWords: Helper.abuseWords) {
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
                    print(senderId)
                    let autoId = Helper.dbRef.childByAutoId().key!
                    let senderPic = Helper.userDataDic["profileImage"] as? String ?? ""
                    let userName = Helper.userDataDic["fullName"] as? String ?? ""
                    let message = self.msgTV.text.condensingWhitespace()
                    let fromParas = ["date_time":finaldate,"from":senderId,"meassage":message,"msg_key":autoId,"read":"1","sender_pic":senderPic,"type":"txt","user_name":userName]
                    let fromParas1 = ["date_time":finaldate,"from":senderId,"meassage":message,"msg_key":autoId,"read":"1","sender_pic":senderPic,"type":"txt","user_name":userName]
                    let lastMsg = ["formatedDateAndTime":finaldate,"read":"0","from":Helper.userId,"msg":message,"time":"\(Date().millisecondsSince1970)"]
                    Helper.dbRef.child("chat").child("Users").child(senderId).child("chat").child(fromId).child(autoId).setValue(fromParas)
                    Helper.dbRef.child("chat").child("Users").child(fromId).child("chat").child(senderId).child(autoId).setValue(fromParas1)
                    Helper.dbRef.child("chat").child("Users").child(senderId).child("lastmsg").child(fromId).setValue(lastMsg)
                    Helper.dbRef.child("chat").child("Users").child(fromId).child("lastmsg").child(senderId).setValue(lastMsg)
                    self.msgTV.text = ""
                } else {
//                    errorWithTitleMsg(title: "no_network".localizableString(loc: Helper.strLan), message: "please_connect_to_internet".localizableString(loc: Helper.strLan))
                    return
                }
                
            })
            
        }
    }
}



// MARK: - tableview extension
extension ChattingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgsdataDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingTableCell", for: indexPath) as! ChattingTableCell
        
        
        if  msgsdataDic[indexPath.row]["type"] as? String ?? "" == "txt" {
            if msgsdataDic[indexPath.row]["from"] as? String ?? "" == Helper.userId{
                cell.senderMsgLbl.text = msgsdataDic[indexPath.row]["meassage"] as? String ?? ""
                let dateFromDataBase = msgsdataDic[indexPath.row]["date_time"] as? String ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss Z"
                let date = dateFormatter.date(from: dateFromDataBase)
                let dateMili = date?.millisecondsSince1970
                let dateVar = Date(timeIntervalSince1970: Double(dateMili ?? Int64(0.0)) / 1000.0)
                cell.senderDateLbl.text = getPastTime(for: dateVar)
                cell.senderTxtStack.isHidden = false
                cell.recieverTxtStack.isHidden = true
            }else{
                cell.recieverMsgLbl.text = msgsdataDic[indexPath.row]["meassage"] as? String ?? ""
                let dateFromDataBase = msgsdataDic[indexPath.row]["date_time"] as? String ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss Z"
                let date = dateFormatter.date(from: dateFromDataBase)
                let dateMili = date?.millisecondsSince1970
                let dateVar = Date(timeIntervalSince1970: Double(dateMili ?? Int64(0.0)) / 1000.0)
                cell.recieverDateLbl.text = getPastTime(for: dateVar)
                cell.recieverTxtStack.isHidden = false
                cell.senderTxtStack.isHidden = true
            }
        }else{
            if msgsdataDic[indexPath.row]["from"] as? String ?? "" == Helper.userId{
                let msgUrl = msgsdataDic[indexPath.row]["meassage"] as? String ?? ""
                
                let dateFromDataBase = msgsdataDic[indexPath.row]["date_time"] as? String ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss Z"
                let date = dateFormatter.date(from: dateFromDataBase)
                let dateMili = date?.millisecondsSince1970
                let dateVar = Date(timeIntervalSince1970: Double(dateMili ?? Int64(0.0)) / 1000.0)
                cell.senderDateLbl.text = getPastTime(for: dateVar)
                cell.recieverTxtStack.isHidden = true
                cell.senderTxtStack.isHidden = true
                
            }else{
                let dateFromDataBase = msgsdataDic[indexPath.row]["date_time"] as? String ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss Z"
                let date = dateFormatter.date(from: dateFromDataBase)
                let dateMili = date?.millisecondsSince1970
                let dateVar = Date(timeIntervalSince1970: Double(dateMili ?? Int64(0.0)) / 1000.0)
                cell.recieverDateLbl.text = getPastTime(for: dateVar)
                cell.recieverTxtStack.isHidden = true
                cell.senderTxtStack.isHidden = true
            }
            
        }
        

        cell.recieverBGView.layer.cornerRadius = 7
        cell.senderBGView.layer.cornerRadius = 7

        cell.recieverBGView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMinYCorner]
        cell.senderBGView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMinYCorner]
        return cell
    }
    
    
}


extension String {
    func condensingWhitespace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}
