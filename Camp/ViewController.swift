//
//  ViewController.swift
//  Camp
//
//  Created by NMAS Amaral on 03/04/21.
//

import UIKit
import Alamofire
class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var buttonEnter: UIButton!
    @IBOutlet weak var gradientImage: UIImageView!
    @IBOutlet weak var logoPrincipal: UIImageView!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var credentials: UILabel!
    var myToken:String?
    var myClient:String?
    var myUid:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gradientImage.bringSubviewToFront(logoPrincipal)
        self.gradientImage.bringSubviewToFront(mainText)
        buttonEnter.backgroundColor = UIColor(red: 240/255, green: 0/255, blue: 100/255, alpha: 1.0)
        logoView.backgroundColor = UIColor(red: 191/255, green: 0/255, blue: 140/255, alpha: 1.0)
        logoView.layer.cornerRadius = 80
        logoView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        gradientImage.layer.cornerRadius = 80
        gradientImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Olhinho"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width-25), y: 5.0, width: 25.0, height: 25.0)
        button.addTarget(self, action: #selector(eyeAction), for: .touchUpInside)
        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
    }
    
    @objc func eyeAction(){
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func enterAction(_ sender: Any) {
        let parameters = ["email": emailTextField.text, "password": passwordTextField.text]
        AF.request(URL(string:"https://empresas.ioasys.com.br/api/v1/users/auth/sign_in")!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON{response in
            self.myToken = (response.response?.allHeaderFields["access-token"] ?? "") as! String
            self.myClient = (response.response?.allHeaderFields["client"] ?? "")as! String
            self.myUid = (response.response?.allHeaderFields["uid"] ?? "")as! String
            if self.myToken == ""{
                self.credentials.isHidden = false
                self.passwordTextField.layer.borderWidth = 2
                self.passwordTextField.layer.borderColor = UIColor.red.cgColor
                self.emailTextField.layer.borderWidth = 2
                self.emailTextField.layer.borderColor = UIColor.red.cgColor
                return
            } else{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                if let companiesvc = storyBoard.instantiateViewController(identifier: "CompaniesVcID")as? CompaniesViewController{
                    companiesvc.token = self.myToken
                    companiesvc.client = self.myClient
                    companiesvc.uid = self.myUid
                    companiesvc.modalPresentationStyle = .fullScreen
                    self.present(companiesvc, animated: true, completion: nil)
                
                }
                
            }
        }
    }
    
}

