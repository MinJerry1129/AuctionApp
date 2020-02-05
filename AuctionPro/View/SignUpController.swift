//
//  SignUpController.swift
//
//
//  Created by Ertuğrul Üngör on 29.11.2017.
//

import UIKit
import Alamofire

class SignUpController: UIViewController {
    var firstVC : LoginController! = nil
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var countryCode: DropDown!
    @IBOutlet weak var txtMobileNum: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtComfirmUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtComfirmPassword: UITextField!
    var countryC = ""
    var country_Mobile : [String] = []
    override func viewDidLoad() {
        let option = Options()
        let restoreData = Data(base64Encoded: option.base64)
        let restoreString = String(data: restoreData!, encoding: .utf8)
        let data = Data(restoreString!.utf8)
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                // try to read out a string array
                for i in 0 ... (json.count)-1 {
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
        super.viewDidLoad()
    }
    @IBAction func btnSignUp(_ sender: UIButton) {
        let name = txtName.text!
        let email = txtEmail.text!
        
        let mobilenum = txtMobileNum.text!
        let username = txtUserName.text!
        let comfirmusername = txtComfirmUserName.text!
        let password = txtPassword.text!
        let comfirmPassword = txtComfirmPassword.text!
        let mobile_num = "(" + countryC + ")" + mobilenum
        print(name)
        print(email)
        print(mobilenum)
        print(countryC)
        print(username)
        print(comfirmusername)
        print(password)
        print(comfirmPassword)
        if name != "" && email != "" && countryC != "" && mobilenum != "" && username != "" && comfirmusername != "" && password != "" && comfirmPassword != ""{
            if password == comfirmPassword {
                if username == comfirmusername{
                    
                    let parameters: Parameters = ["username":name, "email": email, "mobile": mobile_num ,"name": username ,"password":password]
                    
                    Alamofire.request(Global.baseUrl + "iuserregister.php", method: .post, parameters: parameters).responseJSON{ response in
                        if let value = response.value as? [String: AnyObject] {
                            let status = value["status"] as! String
                            if status == "ok" {
                                let alert = UIAlertController(title: "Success", message: "Please Login", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (r) in
                                    _ = self.navigationController?.popViewController(animated: true)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            } else if status == "existuser" {
                                let alert = UIAlertController(title: "Alert", message: "This user already registered", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }else if status == "existmobile" {
                                let alert = UIAlertController(title: "Alert", message: "This mobile already registered", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            } else{
                                let alert = UIAlertController(title: "Alert", message: "unexpected error", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }else{
                    let alert = UIAlertController(title: "Alert", message: "Username not equal! ", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else{
                let alert = UIAlertController(title: "Alert", message: "Passwords not equal! ", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        } else{
            let alert = UIAlertController(title: "Alert", message: "Fields can not be empty! ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginBack(_ sender: UIButton) {
        self.firstVC = self.storyboard?.instantiateViewController(withIdentifier: "firstVC") as? LoginController
        self.present(self.firstVC, animated: true, completion: nil)
    }
}



