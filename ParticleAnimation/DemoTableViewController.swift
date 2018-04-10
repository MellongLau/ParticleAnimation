//
//  DemoTableViewController.swift
//  ParticleAnimation
//
//  Created by Long on 2018/4/10.
//  Copyright © 2018年 Long. All rights reserved.
//

import UIKit


class DemoTableViewController: UITableViewController {
    let datasource = ["Shape", "Tree", "Spider", "Cloth", "Particle System"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Particle Animation"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datasource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = datasource[indexPath.row]

        return cell
    }
 

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let viewController = segue.destination as? ViewController, let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        viewController.title = datasource[indexPath.row]
    }
    

}
