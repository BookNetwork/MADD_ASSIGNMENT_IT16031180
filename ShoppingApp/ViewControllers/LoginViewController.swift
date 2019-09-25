//
//  ViewController.swift
//  ShoppingApp
//
//  Created by Fazlan on 9/16/19.
//  Copyright © 2019 Fazlan. All rights reserved.
//

import UIKit
import SwiftyJSON

enum LoginRole {
    case BUYER
    case SELLER
}

var appDelegate =  UIApplication.shared.delegate as! AppDelegate

class LoginViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    @IBOutlet weak var btnBuyer: UIButton!
    @IBOutlet weak var btnSeller: UIButton!
    
    
    //MARK: Variables
    var loginRole: LoginRole = .BUYER
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: Actions
    @IBAction func pressedLogin(_ sender: Any) {
        proceedWithLogin()
    }
    
    @IBAction func pressedRegister(_ sender: Any) {
        proceedWithRegister()
    }
    
    @IBAction func pressedBuyer(_ sender: Any) {
        loginRole = .BUYER
        
        btnBuyer.setTitleColor(UIColor.black, for: .normal)
        btnBuyer.backgroundColor = UIColor(hexString: "#BFD730")
        
        btnSeller.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        btnSeller.backgroundColor = UIColor(hexString: "#353439")
    }
    
    @IBAction func pressedSeller(_ sender: Any) {
        loginRole = .SELLER
        
        btnSeller.setTitleColor(UIColor.black, for: .normal)
        btnSeller.backgroundColor = UIColor(hexString: "#BFD730")
        
        btnBuyer.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        btnBuyer.backgroundColor = UIColor(hexString: "#353439")
    }
    
    
    //MARK: Functions
    func setupUI() {
        btnBuyer.setTitleColor(UIColor.black, for: .normal)
        btnBuyer.backgroundColor = UIColor(hexString: "#BFD730")
        
        btnSeller.setTitleColor(UIColor.white, for: .normal)
        btnSeller.backgroundColor = UIColor(hexString: "#353439")
    }
    
    func showOkAlert(title: String, body: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func proceedWithLogin() {
        if (txtEmail.text?.isEmpty == false) && (txtPassword.text?.isEmpty == false) {
            let url = "https://reqres.in/api/login"
            let param: [String: Any] = [
                "email": txtEmail.text ?? "",
                "password": txtPassword.text ?? ""
            ]
            
            //using network request class
            //shiow progress
            NetworkRequest.shared.sendPostRequest(url: url, requestType: .post, param: param) { (response, error) in
                //stop progress
                if error == nil {
                    self.navigateToSpecificHome(loginRole: self.loginRole)
                } else {
                    if let data = response?.data {
                        let json = try! JSON(data: data)
                        var errorString: String?
                        errorString = json["error"].stringValue
                        self.showOkAlert(title: "Alert", body: errorString ?? "Unknown error occoured")
                    }
                }
            }
        } else {
            showOkAlert(title: "Alert", body: "Email or password is required to login")
        }
    }
    
    func proceedWithRegister() {
        if (txtEmail.text?.isEmpty == false) && (txtPassword.text?.isEmpty == false) {
            let url = "https://reqres.in/api/register"
            let param: [String: Any] = [
                "email": txtEmail.text ?? "",
                "password": txtPassword.text ?? ""
            ]
            
            NetworkRequest.shared.sendPostRequest(url: url, requestType: .post, param: param) { (response, error) in
                if error == nil {
                    self.showOkAlert(title: "Alert", body: "Successfulluy registered")
                    self.txtEmail.text = ""
                    self.txtPassword.text = ""
                } else {
                    if let data = response?.data {
                        let json = try! JSON(data: data)
                        var errorString: String?
                        errorString = json["error"].stringValue
                        self.showOkAlert(title: "Alert", body: errorString ?? "Unknown error occoured")
                    }
                }
            }
        } else {
            showOkAlert(title: "Alert", body: "Email and password is required to register")
        }
    }
    
    func navigateToSpecificHome(loginRole: LoginRole) {
        switch loginRole {
        case .BUYER:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewVC = storyBoard.instantiateViewController(withIdentifier: "buyerHomeNavVC") as! UINavigationController
            appDelegate.window?.rootViewController = viewVC
        case .SELLER:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewVC = storyBoard.instantiateViewController(withIdentifier: "sellerHomeNavVC") as! UINavigationController
            appDelegate.window?.rootViewController = viewVC
        }
    }
    
}

