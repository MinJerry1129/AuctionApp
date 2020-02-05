//
//  ViewController.swift
//  dancontrol
//
//  Created by Ertuğrul Üngör on 21/11/2017.
//  Copyright © 2017 Dancontrol. All rights reserved.
//

import UIKit
import Alamofire
import iOSDropDown
import JTMaterialSpinner
class LoginController: UIViewController, UITextFieldDelegate {
    var homeVC : HomeVC! = nil
    var profileVC: ProfileVC! = nil
    @IBOutlet weak var viewVC1: UIView!
    @IBOutlet weak var viewVC2: UIView!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet var countryCode: DropDown!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var phoneNum: UITextField!
    var countryC = ""
    var username = ""
    var name = ""
    var role = ""
    var avator = ""
    var mobile = ""
    var email = ""
    var animateDistance: CGFloat!
    var country_Name : [String] = []
    var country_Mobile : [String] = []
    var country_Code : [String] = []
    var spinnerView = JTMaterialSpinner()
    override func viewDidLoad() {
        super.viewDidLoad()
        let option = Options()
        let restoreData = Data(base64Encoded: option.base64)
        let restoreString = String(data: restoreData!, encoding: .utf8)
        let data = Data(restoreString!.utf8)
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                // try to read out a string array
                for i in 0 ... (json.count)-1 {
                    country_Name.append(json[i]["name"] as! String)
                    country_Code.append(json[i]["code"] as! String)
                    country_Mobile.append(json[i]["dial_code"] as! String)
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        countryCode.optionArray = country_Mobile
        countryCode.didSelect{(selectedText , index , id) in
            self.countryC = selectedText
        }
    }
    
    @IBAction func userVCChange(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            viewVC1.isHidden = false
            viewVC2.isHidden = true
        case 1:
            viewVC1.isHidden = true
            viewVC2.isHidden = false
        default:
            break
        }
    }
    @IBAction func login(_ sender: UIButton) {
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let index_seg = segmentedControl.selectedSegmentIndex
        let username = txtUser.text!
        let password = txtPassword.text!
        let mobileN = phoneNum.text!
        print(countryC)
        let phoneN = "(" + countryC + ")" + mobileN
        if index_seg == 0 {
            let parameters: Parameters = ["username": username, "password": password]
            
            Alamofire.request(Global.baseUrl + "iverifyuser.php", method: .post, parameters: parameters).responseJSON{ response in
                print(response)
                if let value = response.value as? [String: AnyObject] {
                    let status = value["status"] as! String
                    if status == "ok" {
                        
                        self.name = value["name"] as! String
                        self.mobile = value["mobile"] as! String
                        self.role = value["role"] as! String
                        self.email = value["email"] as! String
                        self.avator = value["avatar"] as! String
                        self.username = value["username"] as! String
                        Defaults.save(self.name, with: Defaults.NAME_KEY)
                        Defaults.save(self.mobile, with: Defaults.MOBILE_KEY)
                        Defaults.save(self.role, with: Defaults.ROLE_KEY)
                        Defaults.save(self.email, with: Defaults.EMAIL_KEY)
                        Defaults.save(self.avator, with: Defaults.AVATAR_KEY)
                        Defaults.save(self.username, with: Defaults.USERNAME_KEY)
                        self.spinnerView.endRefreshing()
                        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
                        self.present(self.homeVC, animated: true, completion: nil)
                        //self.performSegue(withIdentifier: "loginToTabbarSegue", sender: self)
                    }else{
                        self.spinnerView.endRefreshing()
                        let alert = UIAlertController(title: "Alert", message: "Your username or password wrong! ", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        if index_seg == 1 {
            let parameters: Parameters = ["username": phoneN, "password": password]
            print(mobileN)
            Alamofire.request(Global.baseUrl + "iverifyuser.php", method: .post, parameters: parameters).responseJSON{ response in
                print(response)
                if let value = response.value as? [String: AnyObject] {
                    let status = value["status"] as! String
                    if status == "mobile" {
                        self.name = value["name"] as! String
                        self.mobile = value["mobile"] as! String
                        self.role = value["role"] as! String
                        self.email = value["email"] as! String
                        self.avator = value["avatar"] as! String
                        self.username = value["username"] as! String
                        Defaults.save(self.name, with: Defaults.NAME_KEY)
                        Defaults.save(self.mobile, with: Defaults.MOBILE_KEY)
                        Defaults.save(self.role, with: Defaults.ROLE_KEY)
                        Defaults.save(self.email, with: Defaults.EMAIL_KEY)
                        Defaults.save(self.avator, with: Defaults.AVATAR_KEY)
                        Defaults.save(self.username, with: Defaults.USERNAME_KEY)
                        self.spinnerView.endRefreshing()
                        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
                        self.present(self.homeVC, animated: true, completion: nil)
                        
                    }else{
                        self.spinnerView.endRefreshing()
                        let alert = UIAlertController(title: "Alert", message: "Your phonenumber or password wrong! ", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
        
    }
}

