//
//  ChatListVC.swift
//  ChatFish
//
//  Created by apple on 25/10/2022.
//

import UIKit
import FirebaseFirestore

class ChatListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var allusersDataDic:[NSDictionary] = []
    @IBOutlet weak var chatTable: UITableView!
    let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllusers()
        addLable()
        self.title = "All Buddies"
        navigationController?.navigationBar.prefersLargeTitles = true
        chatTable.delegate = self
        chatTable.dataSource = self
        getuserData()
    }
    func addLable(){
        lbl.center = self.view.center
        lbl.textAlignment = .center
        lbl.text = "No user found"
        self.view.addSubview(lbl)
        lbl.isHidden = true
        
    }
    func getAllusers(){
        self.showIndicator()
        Helper.firRef.collection("Users").getDocuments { querySnap, error in
            if error != nil{
                self.hideIndicator()
            }else{
                for item in querySnap!.documents{
                    let dict = item.data() as NSDictionary
                    if dict["id"] as? String ?? "" != Helper.userId {
                        self.allusersDataDic.append(dict)
                        if self.allusersDataDic == []{
                            self.lbl.isHidden = false
                        }else{
                            self.lbl.isHidden = true
                        }
                        self.chatTable.reloadData()
                    }
                    self.chatTable.reloadData()
                    self.hideIndicator()
                }
            }
        }
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allusersDataDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatListCell", for: indexPath) as! chatListCell
        
        
        cell.nameLbl.text = allusersDataDic[indexPath.row]["fullName"] as? String ?? ""
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChattingVC") as! ChattingVC
        vc.fromId = allusersDataDic[indexPath.row]["id"] as? String ?? ""
        vc.fromIdName = allusersDataDic[indexPath.row]["fullName"] as? String ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getuserData(){
        Helper.firRef.collection("Users").document(Helper.userId).addSnapshotListener { snapShot, error in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                if snapShot?.exists != false{
                    let dict = (snapShot?.data()!)! as NSDictionary
                    Helper.userDataDic = dict
                }
            }
        }
    }
}
