//
//  ForgotPasswordController.swift
//  dancontrol
//
//  Created by Ertuğrul Üngör on 29.11.2017.
//  Copyright © 2017 Dancontrol. All rights reserved.
//

import UIKit
import Alamofire
class ForgotPasswordController: UIViewController {
    var countryc = ""
    var country_Mobile : [String] = []
    
    @IBOutlet weak var txtusername: UITextField!
    @IBOutlet weak var txtmobile: UITextField!
    @IBOutlet weak var countrmobile: DropDown!
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
                    country_Mobile.append(json[i]["dial_code"] as! String)
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        countrmobile.optionArray = country_Mobile
        countrmobile.didSelect{(selectedText , index , id) in
            self.countryc = selectedText
        }
    }
    @IBAction func resetBtn(_ sender: UIButton) {
        let mobilenum = "(" + countryc + ")" + txtmobile.text!
        let parameters: Parameters = ["username": txtusername.text!, "mobile": mobilenum]
        print(mobilenum)
        Alamofire.request(Global.baseUrl + "iresetpassword.php", method: .post, parameters: parameters).responseJSON{ response in
            print(response)
            if let value = response.value as? [String: AnyObject] {
                let status = value["status"] as! String
                if status == "ok" {
                    let alert = UIAlertController(title: "Alert", message: "okokokokoko ", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Alert", message: "Your username or password wrong! ", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func gologin(_ sender: Any) {
        self.dismiss(animated: true, completion:nil)
    }
}
