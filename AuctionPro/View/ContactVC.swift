//
//  SignUpController.swift
//
//
//  Created by Ertuğrul Üngör on 29.11.2017.
//

import UIKit
import Alamofire

class ContactVC: UIViewController {
    var login : LoginController! = nil
    var profile : ProfileVC! = nil
    var purchase : PurchaseVC! = nil
    var winnerVC : WinnerVC! = nil
    var contactVC : ContactVC! = nil
    var homeVC: HomeVC! = nil
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var txtmsg: UITextView!
    override func viewDidLoad() {
        userName.text = Defaults.getNameAndValue(Defaults.USERNAME_KEY)
        txtEmail.text = Defaults.getNameAndValue(Defaults.EMAIL_KEY)
        let imgUrl = Global.imageUrl + Defaults.getNameAndValue(Defaults.AVATAR_KEY)
        let url = URL(string: imgUrl)
        let screenSize: CGRect = UIScreen.main.bounds
        avatarImg.frame = CGRect(x: 0, y: 0, width: screenSize.height * 0.2, height: screenSize.height * 0.2)
        avatarImg.layer.borderWidth = 1
        avatarImg.layer.masksToBounds = false
        avatarImg.layer.borderColor = UIColor.black.cgColor
        avatarImg.layer.cornerRadius = avatarImg.frame.height/2
        avatarImg.clipsToBounds = true
        print(avatarImg.frame.height)
        print(avatarImg.layer.cornerRadius)
        do {
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            avatarImg.image = image
            
        }catch let err {
            print("Error : \(err.localizedDescription)")
        }
        
        super.viewDidLoad()
    }
    @IBAction func gobackbtn(_ sender: Any) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.present(self.homeVC, animated: true, completion: nil)
    }
    @IBAction func loginBack(_ sender: UIButton) {
        self.login = self.storyboard?.instantiateViewController(withIdentifier: "firstVC") as? LoginController
        self.present(self.login, animated: true, completion: nil)
    }
    
    @IBAction func viewProfile(_ sender: UIButton) {
        self.profile = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as? ProfileVC
        self.present(self.profile, animated: true, completion: nil)
    }
    
    @IBAction func viewHome(_ sender: UIButton) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.present(self.homeVC, animated: true, completion: nil)
    }
    
    @IBAction func viewpurchase(_ sender: UIButton) {
        self.purchase = self.storyboard?.instantiateViewController(withIdentifier: "purchaseVC") as? PurchaseVC
        self.present(self.purchase, animated: true, completion: nil)
    }
    @IBAction func viewWonbids(_ sender: UIButton) {
        self.winnerVC = self.storyboard?.instantiateViewController(withIdentifier: "winnerVC") as? WinnerVC
        self.present(self.winnerVC, animated: true, completion: nil)
    }
    
    
    @IBAction func saveBtn(_ sender: UIButton)
    {
        if txtmsg.text! != "" {
            let parameters: Parameters = ["username": Defaults.getNameAndValue(Defaults.USERNAME_KEY), "message" : txtmsg.text! ]
            Alamofire.request(Global.baseUrl + "isendMessage.php", method: .post, parameters: parameters).responseJSON{ response in
                print(response)
                if let value = response.value as? [String: AnyObject] {
                    let status = value["status"] as! String
                    if status == "ok" {
                        let alert = UIAlertController(title: "Alert", message: "Okokok", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
