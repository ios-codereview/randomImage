//
//  ImageCollectionViewController.swift
//  randomImage
//
//  Created by Hyeontae on 07/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class ImageCollectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    private let test = ["1","2","3","4","5"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as? TestCell else { fatalError("nop") }
        cell.label.text = test[indexPath.row]
        return cell
    }
    

}
