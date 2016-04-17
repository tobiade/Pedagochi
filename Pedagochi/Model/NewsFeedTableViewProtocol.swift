//
//  NewsFeedTableViewProtocol.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 17/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation

protocol NewsFeedTableViewProtocol {
    func cellDeqeueForTableView(inout tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> UITableViewCell
}