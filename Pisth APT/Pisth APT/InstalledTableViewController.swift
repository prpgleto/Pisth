// This source file is part of the https://github.com/ColdGrub1384/Pisth open source project
//
// Copyright (c) 2017 - 2018 Adrian Labbé
// Licensed under Apache License v2.0
//
// See https://raw.githubusercontent.com/ColdGrub1384/Pisth/master/LICENSE for license information

import UIKit
import Pisth_Shared

/// Table view controller for listing installed packages.
class InstalledTableViewController: UITableViewController {
    
    /// Refresh.
    ///
    /// - Parameters:
    ///     - sender: Sender refresh control.
    @objc func update(_ sender: UIRefreshControl) {
        
        let activityVC = ActivityViewController(message: "Loading...")
        present(activityVC, animated: true) {
            AppDelegate.shared.searchForUpdates()
            activityVC.dismiss(animated: true, completion: {
                sender.endRefreshing()
            })
        }
        
    }
    
    // MARK: - View controller
    
    /// Setup views.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .clear
        refreshControl?.tintColor = .gray
        refreshControl?.addTarget(self, action: #selector(update(_:)), for: .valueChanged)
    }
    
    // MARK: - Table view data source
    
    /// - Returns: Count of installed packages.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.shared.installed.count
    }
    
    /// - Returns: A cell with the title as the package for current index.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "package") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = AppDelegate.shared.installed[indexPath.row]
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    /// Show package.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let installer = UIStoryboard(name: "Installer", bundle: Bundle.main).instantiateInitialViewController() as? InstallerViewController {
            installer.package = AppDelegate.shared.installed[indexPath.row]
            present(UINavigationController(rootViewController: installer), animated: true, completion: nil)
        }
    }
    
}
