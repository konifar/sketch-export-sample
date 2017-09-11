//
//  ViewController.swift
//  SketchExportSample
//
//  Created by Yusuke Konishi on 2017/09/11.
//  Copyright © 2017年 konifar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var icShoppingCartBlue24 = UIImage(named:"ic_shopping_cart_blue_24")

    @IBOutlet weak var imgView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.image = icShoppingCartBlue24
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

