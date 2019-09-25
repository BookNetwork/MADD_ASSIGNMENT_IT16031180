//
//  BuyerHomeViewController.swift
//  ShoppingApp
//
//  Created by Fazlan on 9/16/19.
//  Copyright © 2019 Fazlan. All rights reserved.
//

import UIKit
import RealmSwift

class BuyerHomeViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    
    
    //MARK: Variables
    var itemsArray: [Items] = [Items]()
    
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TO LOAD TEH REALM DATA TO TABLE VIEW
        itemsArray = Array(try! Realm().objects(Items.self).sorted(byKeyPath: "id", ascending: true))
        
        if itemsArray.count > 0 {
            lblPlaceHolder.isHidden = true
        } else {
            lblPlaceHolder.isHidden = false
        }
        
        tblItems.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
    //MARK: Actions
    @IBAction func pressedLogout(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewVC = storyBoard.instantiateViewController(withIdentifier: "logInNavVC") as! UINavigationController
        appDelegate.window?.rootViewController = viewVC
    }
    
    
    //MARK: Functions
    
    
    
    
}



class BuyerHomeItemsCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var itemContentView: UIView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnBuy: CustomButton!
    
    
    override func awakeFromNib() {
        itemContentView.layer.borderWidth = 1.0
        itemContentView.layer.cornerRadius = 5.0
        itemContentView.layer.borderColor = UIColor(hexString: "#BFD730")?.cgColor
        
        itemImage.layer.borderWidth = 1.0
        itemImage.layer.cornerRadius = 5.0
        itemImage.layer.borderColor = UIColor(hexString: "#BFD730")?.cgColor
    }
    
    
    func configureCell(item: Items) {
        lblTitle.text = item.title
        lblPrice.text = "\(item.itemPrice) Rs"
        itemImage.image = UIImage(data: item.image ?? Data())
    }
    
    
    @IBAction func pressedBuy(_ sender: Any) {
    }
    
    
}


extension BuyerHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemsArray.count > 0 {
            return itemsArray.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "buyerHomeItemsCell") as? BuyerHomeItemsCell {
            let item = itemsArray[indexPath.row]
            cell.configureCell(item: item)
            return cell
        }
        return UITableViewCell()
    }
    
}
