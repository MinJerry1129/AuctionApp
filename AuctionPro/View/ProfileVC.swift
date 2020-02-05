//
//  SignUpController.swift
//
//
//  Created by Ertuğrul Üngör on 29.11.2017.
//

import UIKit
import Alamofire
import JTMaterialSpinner
class ProfileVC: UIViewController {
    var login : LoginController! = nil
    var homeVC : HomeVC! = nil
    var purchase : PurchaseVC! = nil
    var winnerVC : WinnerVC! = nil
    var contactVC : ContactVC! = nil
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var mobileNum: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    var avatarimage : UIImage!
    var avatar_sel = 0
    var avatar_url = ""
    var spinnerView = JTMaterialSpinner()
    override func viewDidLoad() {
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        userName.text = Defaults.getNameAndValue(Defaults.NAME_KEY)
        mobileNum.text = Defaults.getNameAndValue(Defaults.MOBILE_KEY)
        txtEmail.text = Defaults.getNameAndValue(Defaults.EMAIL_KEY)
        avatar_url = Defaults.getNameAndValue(Defaults.AVATAR_KEY)
        if avatar_url == ""{
            avatar_url = "image/profile/default.jpg"
        }
        let imgUrl = Global.imageUrl + avatar_url
        let url = URL(string: imgUrl)
        do {
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            avatarImg.image = image
            spinnerView.endRefreshing()
            
        }catch let err {
            spinnerView.endRefreshing()
            print("Error : \(err.localizedDescription)")
        }
        
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        avatarImg.frame = CGRect(x: 0, y: 0, width: screenSize.height * 0.25, height: screenSize.height * 0.25)
        avatarImg.layer.borderWidth = 1
        avatarImg.layer.masksToBounds = false
        avatarImg.layer.borderColor = UIColor.black.cgColor
        avatarImg.layer.cornerRadius = avatarImg.frame.height/2
        avatarImg.clipsToBounds = true
    }
    
    @IBAction func saveBtn(_ sender: UIButton)
    {
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["username": Defaults.getNameAndValue(Defaults.USERNAME_KEY), "name": userName.text!, "mobile" : mobileNum.text!, "email" : txtEmail.text! ]
        Alamofire.request(Global.baseUrl + "iupdateuser.php", method: .post, parameters: parameters).responseJSON{ response in
            print(response)
            if let value = response.value as? [String: AnyObject] {
                let status = value["status"] as! String
                if status == "ok" {
                    Defaults.save(self.userName.text!, with: Defaults.NAME_KEY)
                    Defaults.save(self.mobileNum.text!, with: Defaults.MOBILE_KEY)
                    Defaults.save(self.txtEmail.text!, with: Defaults.EMAIL_KEY)
                    self.spinnerView.endRefreshing()
                    let alert = UIAlertController(title: "Alert", message: "Profile Updated", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else{
                    self.spinnerView.endRefreshing()
                    let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        if avatar_sel == 1{
            let data = UIImageJPEGRepresentation(avatarimage, 0.6)
            let strBase64 = data!.base64EncodedString(options: .lineLength64Characters)
            let user_avatar = Defaults.getNameAndValue(Defaults.USERNAME_KEY)
            let avatar_url = "image/profile/IMG" + user_avatar + ".jpg"
            let parameters: Parameters = ["username": Defaults.getNameAndValue(Defaults.USERNAME_KEY), "uploadfile" : strBase64 ]
            Alamofire.request(Global.baseUrl + "iupdateavatar.php", method: .post, parameters: parameters).responseJSON{ response in
                print(response)
                if let value = response.value as? [String: AnyObject] {
                    let status = value["status"] as! String
                    if status == "ok" {
                        self.spinnerView.endRefreshing()
                        Defaults.save(avatar_url, with: Defaults.AVATAR_KEY)
                        let alert = UIAlertController(title: "Alert", message: "Updata", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        self.spinnerView.endRefreshing()
                        let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
            
        }
        
    }
    @IBAction func gobackbtn(_ sender: UIButton) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.present(self.homeVC, animated: true, completion: nil)
    }
    @IBAction func logoutBtn(_ sender: UIButton) {
        
        self.login = self.storyboard?.instantiateViewController(withIdentifier: "firstVC") as? LoginController
        self.present(self.login, animated: true, completion: nil)
    }
    @IBAction func goHome(_ sender: UIButton)
    {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.present(self.homeVC, animated: true, completion: nil)
    }
    @IBAction func goPurchase(_ sender: UIButton) {
        self.purchase = self.storyboard?.instantiateViewController(withIdentifier: "purchaseVC") as? PurchaseVC
        self.present(self.purchase, animated: true, completion: nil)
    }
    
    @IBAction func goWonBids(_ sender: UIButton) {
        self.winnerVC = self.storyboard?.instantiateViewController(withIdentifier: "winnerVC") as? WinnerVC
        self.present(self.winnerVC, animated: true, completion: nil)
    }
    
    @IBAction func goContact(_ sender: UIButton) {
        self.contactVC = self.storyboard?.instantiateViewController(withIdentifier: "contactVC") as? ContactVC
        self.present(self.contactVC, animated: true, completion: nil)
    }
    
    @IBAction func selectAvatar(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        //If you want work actionsheet on ipad then you have to use popoverPresentationController to present the actionsheet, otherwise app will crash in iPad
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension ProfileVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            print(editedImage)
            avatarimage = editedImage
            avatar_sel = 1
            self.avatarImg.image = editedImage
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}

