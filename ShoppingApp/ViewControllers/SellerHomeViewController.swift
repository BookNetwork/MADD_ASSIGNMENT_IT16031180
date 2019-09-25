//
//  SellerHomeViewController.swift
//  ShoppingApp
//
//  Created by Fazlan on 9/16/19.
//  Copyright © 2019 Fazlan. All rights reserved.
//

import UIKit
import RealmSwift

class SellerHomeViewController: UIViewController {
    
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
    @IBAction func pressedAddItems(_ sender: Any) {
        let viewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addItemsViewController") as! AddItemsViewController
        viewVC.delegate = self
        self.navigationController?.pushViewController(viewVC, animated: true)
    }
    
    @IBAction func pressedLogOut(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewVC = storyBoard.instantiateViewController(withIdentifier: "logInNavVC") as! UINavigationController
        appDelegate.window?.rootViewController = viewVC
    }
    
    
    //MARK: Functions
    
    
    
    
}

class SellerHomeItemsCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var itemsContentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnEdit: CustomButton!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    override func awakeFromNib() {
        itemsContentView.layer.borderWidth = 1.0
        itemsContentView.layer.cornerRadius = 5.0
        itemsContentView.layer.borderColor = UIColor(hexString: "#BFD730")?.cgColor
        
        itemImage.layer.borderWidth = 1.0
        itemImage.layer.cornerRadius = 5.0
        itemImage.layer.borderColor = UIColor(hexString: "#BFD730")?.cgColor
    }
    
    func configureCell(item: Items) {
        lblTitle.text = item.title
        lblDesc.text = item.itemDesc
        lblPrice.text = "\(item.itemPrice) Rs"
        itemImage.image = UIImage(data: item.image ?? Data())
    }
    
    
}


extension SellerHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemsArray.count > 0 {
            return itemsArray.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "sellerHomeItemsCell") as? SellerHomeItemsCell {
            let item = itemsArray[indexPath.row]
            cell.configureCell(item: item)
            return cell
        }
        return UITableViewCell()
    }
    
}



//extension
extension SellerHomeViewController: AddItemsViewControllerDelegate {
    
    func didAddOrUpdateItem(itemAdded: Bool) {
        if itemAdded {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.itemsArray = Array(try! Realm().objects(Items.self).sorted(byKeyPath: "id", ascending: true))
                if self.itemsArray.count > 0 {
                    self.lblPlaceHolder.isHidden = true
                } else {
                    self.lblPlaceHolder.isHidden = false
                }
                self.tblItems.reloadData()
            }
        }
    }
}
