//
//  Helper.swift
//  ChatFish
//
//  Created by apple on 25/10/2022.
//

import Foundation
import UIKit
import iProgressHUD
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore


let detailLbl = UILabel(frame: CGRect(x: 0, y: 130, width: 200, height: 30))
func showNoData(table:UITableView,deatilText:String = "") {
    detailLbl.font = UIFont.boldSystemFont(ofSize: 20.0)
    detailLbl.text = deatilText
    detailLbl.textAlignment = .center
    detailLbl.tag = 9090
    detailLbl.translatesAutoresizingMaskIntoConstraints = false
    table.addSubview(detailLbl)
    
    table.addConstraint(NSLayoutConstraint(item: detailLbl, attribute: .centerX, relatedBy: .equal, toItem: table, attribute: .centerX, multiplier: 1.0, constant: 1))
    table.addConstraint(NSLayoutConstraint(item: detailLbl, attribute: .centerY, relatedBy: .equal, toItem: table, attribute: .centerY, multiplier: 1.0, constant: 1))
    detailLbl.addConstraint(NSLayoutConstraint(item: detailLbl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150))
    detailLbl.addConstraint(NSLayoutConstraint(item: detailLbl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200))
}
    func removeNoData() {
        detailLbl.removeFromSuperview()
    }



//MARK: - TextView for sms Auto resize

class TextViewAutoHeight: UITextView {

    //MARK: attributes
    var  maxHeight:CGFloat?
    var  heightConstraint:NSLayoutConstraint?

    //MARK: initialize

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUpInit()
    }

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//    }

//    override init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: "")
//        super.init(frame: frame)
//        setUpInit()
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setUpConstraint()
    }

    //MARK: private

    private func setUpInit() {
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                self.heightConstraint = constraint as? NSLayoutConstraint
                break
            }
        }
    }

    private func setUpConstraint() {
        var finalContentSize:CGSize = self.contentSize
        finalContentSize.width  += (self.textContainerInset.left + self.textContainerInset.right ) / 2.0
        finalContentSize.height += (self.textContainerInset.top  + self.textContainerInset.bottom) / 2.0

        fixTextViewHeigth(finalContentSize: finalContentSize)
    }

    private func fixTextViewHeigth(finalContentSize:CGSize) {
        if let maxHeight = self.maxHeight {
            var  customContentSize = finalContentSize;

            customContentSize.height = min(customContentSize.height, CGFloat(maxHeight))

            self.heightConstraint?.constant = customContentSize.height;

            if finalContentSize.height <= self.frame.height {
                let textViewHeight = (self.frame.height - self.contentSize.height * self.zoomScale)/2.0

                self.contentOffset = CGPoint(x: 0, y: -(textViewHeight < 0.0 ? 0.0 : textViewHeight))

            }
        }
    }
}
// MARK: - Error Functions Extension

extension UIViewController {
    func errorWithMsg(message: String = "") {
        let alert = UIAlertController(title: "opps!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func errorWithTitleMsg(title: String = "opps!", message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func getPastTime(for date: Date) -> String {
        var secondsAgo = Int(Date().timeIntervalSince(date))
        if secondsAgo < 0 {
            secondsAgo = secondsAgo * (-1)
        }
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        
        if secondsAgo < minute {
            if secondsAgo < 2 {
                return "just now"
            } else {
                return "now"
            }
        } else if secondsAgo < hour {
            let min = secondsAgo / minute
            if min == 1 {
                return "\(min) minute ago"
            } else {
                return "\(min) minutes ago"
            }
        } else if secondsAgo < day {
            let hr = secondsAgo / hour
            if hr == 1 {
                return "\(hr) hour ago"
            } else {
                return "\(hr) hours ago"
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            // formatter.locale = Locale(identifier: "en_US_POSIX")
            let strDate: String = formatter.string(from: date)
            return strDate
        }
    }
    
}
    // MARK: - Activity Indicator Extension

    extension UIViewController {
       static let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        func showIndicator(caption: String = "Please wait...") {
            self.isEditing = false
            UIViewController.customView.dismissProgress()
            let iprogress = iProgressHUD()
            iprogress.isShowModal = true
            iprogress.isShowCaption = true
            iprogress.boxColor = UIColor.white
            iprogress.alphaBox = 0.3
            iprogress.captionColor = UIColor(red: 2.0/255, green: 137.0/255, blue: 203.0/255, alpha: 1.0)
            iprogress.indicatorColor = UIColor(red: 2.0/255, green: 137.0/255, blue: 203.0/255, alpha: 1.0)
            iprogress.modalColor = .black
            iprogress.captionSize = 16
            iprogress.boxCorner = 20
            iprogress.iprogressStyle = .vertical
            iprogress.isTouchDismiss = false
            iprogress.indicatorSize = 40
            iprogress.captionDistance = 25
            iprogress.boxSize = 35
            iprogress.indicatorStyle = .ballScaleRippleMultiple
            iprogress.attachProgress(toViews: UIViewController.customView)
            UIViewController.customView.updateCaption(text: caption)
            UIViewController.customView.showProgress()
            UIApplication.shared.keyWindow?.addSubview(UIViewController.customView)
        }
        func hideIndicator() {
            UIViewController.customView.dismissProgress()
            UIViewController.customView.removeFromSuperview()
        }
    }



    
    
    
    
    


class Helper{
    
    static var dbRef = Database.database().reference()
    static var strRef = Storage.storage().reference()
    static var firRef = Firestore.firestore()
    static var userId = ""
    static var userDataDic:NSDictionary = [:]
    
    static var abuseWords = ["2g1c 2","girls 1 cup","acrotomophilia","alabama hot pocket","alaskan pipeline","anal","anilingus","anus","apeshit","arsehole","assasshole","assmunch","auto erotic","autoerotic","babeland","baby batter","baby juice","ball gag","ball gravy","ball kicking","ball licking","ball sack","ball sucking","bangbros","bangbus","bareback","barely legal","barenaked","bastard","bastardo","bastinado","bbw","bdsm","beaner","beaners","beaver cleaver","beaver lips","beastiality","bestiality","big black","big breasts","big knockers","big tits","bimbos","birdlock","bitch","bitches","black cock","blonde action","blonde on blonde action","blowjob","blow job","blow your load","blue waffle","blumpkin","bollocks","bondage","boner","boob","boobs","booty call","brown showers","brunette action","bukkake","bulldyke","bullet vibe","bullshit","bung hole","bunghole","busty","butt","buttcheeks","butthole","camel toe","camgirl","camslut","camwhore","carpet muncher","carpetmuncher","chocolate rosebuds","cialis","circlejerk","cleveland steamer","clit","clitoris","clover clamps","clusterfuck","cock","cocks","coprolagnia","coprophilia","cornhole","coon","coons","creampie","cum","cumming","cumshot","cumshots","cunnilingus","cunt","darkie","date rape","daterape","deep throat","deepthroat","dendrophilia","dick","dildo","dingleberry","dingleberries","dirty pillows","dirty sanchez","doggie style","doggiestyle","doggy style","doggystyle","dog style","dolcett","domination","dominatrix","dommes","donkey punch","double dong","double penetration","dp action","dry hump","dvda","eat my ass","ecchi","ejaculation","erotic","erotism","escort","eunuch","fag","faggot","fecal","felch","fellatio","feltch","female squirting","femdom","figging","fingerbang","fingering","fisting","foot fetish","footjob","frotting","fuck","fuck buttons","fuckin","fucking","fucktards","fudge packer","fudgepacker","futanari","gangbang","gang bang","gay sex","genitals","giant cock","girl on","girl on top","girls gone wild","goatcx","goatse","god damn","gokkun","golden shower","goodpoop","goo girl","goregasm","grope","group sex","g-spot","guro","hand job","handjob","hard core","hardcore","hentai","homoerotic","honkey","hooker","horny","hot carl","hot chick","how to kill","how to murder","huge fat","humping","incest","intercourse","jack off","jail bait","jailbait","jelly donut","jerk off","jigaboo","jiggaboo","jiggerboo","jizz","juggs","kike","kinbaku","kinkster","kinky","knobbing","leather restraint","leather straight jacket","lemon party","livesex","lolita","lovemaking","make me come","male squirting","masturbate","masturbating","masturbation","menage a trois","milf","missionary position","mong","motherfucker","mound of venus","mr hands","muff diver","muffdiving","nambla","nawashi","negro","neonazi","nigga","nigger","nig nog","nimphomania","nipple","nipples","nsfw","nsfw images","nude","nudity","nutten","nympho","nymphomania","octopussy","omorashi","one cup two girls","one guy one jar","orgasm","orgy","paedophile","paki","panties","panty","pedobear","pedophile","pegging","penis","phone sex","piece of shit","pikey","pissing","piss pig","pisspig","playboy","pleasure chest","pole smoker","ponyplay","poof","poon","poontang","punany","poop chute","poopchute","porn","porno","pornography","prince albert piercing","pthc","pubes","pussy","queaf","queef","quim","raghead","raging boner","rape","raping","rapist","rectum","reverse cowgirl","rimjob","rimming","rosy palm","rosy palm and her 5 sisters","rusty trombone","sadism","santorum","scat","schlong","scissoring","semen","sex","sexcam","sexo","sexy","sexual","sexually","sexuality","shaved beaver","shaved pussy","shemale","shibari","shit","shitblimp","shitty","shota","shrimping","skeet","slanteye","slut","s&m","smut","snatch","snowballing","sodomize","sodomy","spastic","spic","splooge","splooge moose","spooge","spread legs","spunk","strap on","strapon","strappado","strip club","style doggy","suck","sucks","suicide girls","sultry women","swastika","swinger","tainted love","taste my","tea bagging","threesome","throating","thumbzilla","tied up","tight white","tit","tits","titties","titty","tongue in a","topless","tosser","towelhead","tranny","tribadism","tub girl","tubgirl","tushy","twat","twink","twinkie","two girls one cup","undressing","upskirt","urethra play","urophilia","vagina","venus mound","viagra","vibrator","violet wand","vorarephilia","voyeur","voyeurweb","voyuer","vulva","wank","wetback","wet dream","white power","whore","worldsex","wrapping men","wrinkled starfish","xx","xxx","yaoi","yellow showers","yiffy","zoophilia"]
}
// MARK: - Date Extension

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
