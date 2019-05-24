//
//  PhotoDataSource.swift
//  GYBITG
//
//  Created by juanita aguilar on 5/24/19.
//

import Foundation
import UIKit

class VideoDataSource: NSObject, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if using custom ItemCell do this instead of line above to deque a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        
        //set the text on the cell with the description of this item
        //that is at the nth index of items, where n = row
        //this cell will appera in on the table view
        let video = mockVideoRepopsitory.videos[indexPath.row]
        
        /** cell.textLabel?.text = item.name
         cell.detailTextLabel?.text = "$\(item.valueInDollars)"*/
        
        //configure the custom cell with the Item
        cell.Description.text = video.description
        cell.videoDuration.text = "\(video.videoDuration)"
        cell.thumbnail.imageView?.image = video.thumbnail
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return mockVideoRepopsitory.videos.count
    }
    
    
    var videos = [Video]()
    
    var mockVideoRepopsitory = MockVideoRepository()
    //required func of the UITableViewDataSource Protocol this returns an int for the number of rows in the table a row for each item
   // override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int{
    //    return mockVideoRepopsitory.videos.count
    //}
    
    //second required fx the UITableViewDataSource Protocol This is the nth row displays the nth entry in the allItems array. Asks the datasource for a cell to insert in a particular location of the table view.
    /**override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create an istance of UITableViewCell, with default appearance
        //dont use if you have the resue code
        // let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        //Get a row or recycled cell
        //Will check the pool or or quee of cells to see if a cell with the correct reuse identifier already exists. If not a new cell will be created and returned
        //The identifier UITableViewCell was created in the storyBoard by selecting the cell in the ui and the attributes to indtifier and selecting the style to right Detail
        // let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        //if using custom ItemCell do this instead of line above to deque a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        
        //set the text on the cell with the description of this item
        //that is at the nth index of items, where n = row
        //this cell will appera in on the table view
        let video = mockVideoRepopsitory.videos[indexPath.row]
        
        /** cell.textLabel?.text = item.name
         cell.detailTextLabel?.text = "$\(item.valueInDollars)"*/
        
        //configure the custom cell with the Item
        cell.Description.text = video.description
        cell.videoDuration.text = "\(video.videoDuration)"
        cell.thumbnail.imageView?.image = video.thumbnail
    
      
        
        return cell
    }*/
    
    
    
}
