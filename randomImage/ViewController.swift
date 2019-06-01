//
//  ViewController.swift
//  randomImage
//
//  Created by Hyeontae on 28/05/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let test = TestResource(urlString: "https://jsonplaceholder.typicode.com/posts/1")
        let manager = APIManager.init(resource: test)
        manager.getDate()
    }


}

