//
//  ViewController.swift
//  YahooRSS
//
//  Created by Takashi Yamamoto on 2015/03/10.
//  Copyright (c) 2015年 Takashi Yamamoto. All rights reserved.
//

import UIKit
import Bond
import SwiftyJSON

class ListViewController: UITableViewController {
    
    var tableViewDataSourceBond: UITableViewDataSourceBond<UITableViewCell>!
    let urlString = "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://rss.dailynews.yahoo.co.jp/fc/rss.xml&num=20"
    var news:DynamicArray<AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.news = DynamicArray([])
        self.tableViewDataSourceBond = UITableViewDataSourceBond(tableView: self.tableView)
        var request = NSURLRequest(URL: NSURL(string:self.urlString)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (res: NSURLResponse!, data: NSData!, error: NSError!) in
            
            let json = JSON(NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil) as NSDictionary)
            self.news = DynamicArray(json["responseData"]["feed"]["entries"].arrayObject!)

            self.news.map { (entry: AnyObject) -> UITableViewCell in
                let result:NSDictionary = entry as NSDictionary
                let cell = (self.tableView.dequeueReusableCellWithIdentifier("cell") as? ListViewCell)!
                let title:Dynamic<String> = Dynamic(result["title"] as String)
                
                title ->> cell.label
                return cell
                
            } ->> self.tableViewDataSourceBond
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("detail", sender:self.news[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail"{
            var detailViewController = segue.destinationViewController as DetailViewController
            detailViewController.entry = sender as NSDictionary
        }
        
    }

}

class ListViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!

}

