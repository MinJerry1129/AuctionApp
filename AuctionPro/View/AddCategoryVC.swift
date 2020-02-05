import UIKit
import Alamofire
import JTMaterialSpinner
class AddCategoryVC: UIViewController {
    var loger : LoginController! = nil
    var profile : ProfileVC! = nil
    var purchase : PurchaseVC! = nil
    var winnerVC : WinnerVC! = nil
    var contactVC : ContactVC! = nil
    var homeVC: HomeVC! = nil
    
    var imagePicker = UIImagePickerController()
    var categoryimage :UIImage!
    var img_sel = 0
    @IBOutlet weak var categoryimg: UIImageView!
    
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var add_category: UIButton!
    var spinnerView = JTMaterialSpinner()
    override func viewDidLoad() {
        categoryimg.isHidden = true
        super.viewDidLoad()
    }
    @IBAction func postBtn(_ sender: UIButton) {
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        
        if img_sel == 1{
            self.spinnerView.beginRefreshing()
            let data = UIImageJPEGRepresentation(categoryimage, 0.6)
            let strBase64 = data!.base64EncodedString(options: .lineLength64Characters)
            let parameters: Parameters = ["categoryname": txtCategory.text!, "uploadfile" : strBase64 ]
            Alamofire.request(Global.baseUrl + "icategoryregister.php", method: .post, parameters: parameters).responseJSON{ response in
                print(response)
                if let value = response.value as? [String: AnyObject] {
                    let status = value["status"] as! String
                    if status == "ok" {
                        self.add_category.isEnabled = false
                        self.spinnerView.endRefreshing()
                        let alert = UIAlertController(title: "Alert", message: "New Category Added", preferredStyle: UIAlertControllerStyle.alert)
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
    
    @IBAction func getphotoBtn(_ sender: UIButton) {
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
    @IBAction func gobackbtn(_ sender: Any) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.present(self.homeVC, animated: true, completion: nil)
    }
    @IBAction func loginBack(_ sender: UIButton) {
        self.loger = self.storyboard?.instantiateViewController(withIdentifier: "firstVC") as? LoginController
        self.present(self.loger, animated: true, completion: nil)
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
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func viewContact(_ sender: Any) {
        self.contactVC = self.storyboard?.instantiateViewController(withIdentifier: "contactVC") as? ContactVC
        self.present(self.contactVC, animated: true, completion: nil)
    }
    
    
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
extension AddCategoryVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            print(editedImage)
            categoryimg.isHidden = false
            categoryimage = editedImage
            img_sel = 1
            self.categoryimg.image = editedImage
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
