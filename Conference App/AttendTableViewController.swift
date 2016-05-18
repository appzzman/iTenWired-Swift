//
//  AttendeesViewController.swift
//  Conference App
//
//  Created by tuong on 4/11/16.
//  Copyright © 2016 Chrystech Systems. All rights reserved.
//

import UIKit

class AttendeesViewController: UITableViewController{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let atendeeControler = AttendeeController()
    
    var sponsers:[Sponser] = []
    var exhibitors:[Exibitor] = []
    var speakers:[Speaker] = []
    
    // Photo Loader and controller for exhibitor photos
    var exhibitorPhotos = [Photorecord]()
    let exibitorPendingOperations = PendingOperarions()
    
    
    // Photo loader and controller for sponsers
    var sponserPhotos = [Photorecord]()
    let sponserPendingoperations = PendingOperarions()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            //Gets attendees Data
            self.loadSponsers()
            self.loadExhibitors()
            self.speakers = self.atendeeControler.getSpeakers()
            
            // Deactivates Activity indicator
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            
            //Relaods TableView Data
            self.tableView.reloadData()
        }
    }
    
    internal func loadSponsers(){
        let sponsers = self.atendeeControler.getSponsers()
        
        for sponser in sponsers {
            self.sponsers.append(sponser)
            let url = NSURL(string: sponser.logo)
            let photoRecord = Photorecord(name: sponser.logo, url: url!)
            self.sponserPhotos.append(photoRecord)
        }
    }
    
    internal func loadExhibitors(){
        let exhibitors = self.atendeeControler.getExibitors()
        
        for exhibitor in exhibitors {
            self.exhibitors.append(exhibitor)
            let url = NSURL(string: exhibitor.logo)
            let photoRecord = Photorecord(name: exhibitor.logo, url: url!)
            self.exhibitorPhotos.append(photoRecord)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var index = indexPath.row
        
        // Sponser Cell
        if index >= 0 && index <= sponsers.count{
            if index == 0 { //excludes header
                return
            }
            print("\(index-1) cell of sponsers")
        }
        
        index = index - (sponsers.count + 1)
        
        if index >= 0 && index <= exhibitors.count{
            if index == 0{  // Excludes Header
                return
            }
            print("\(index - 1) cell of exhibitors")
        }
        
        index = index - (exhibitors.count + 1)
        
        // Speaker
        if index >= 0 && index <= speakers.count {
            
            if index == 0{
                return
            }
            let storyboard = UIStoryboard.init(name: "Attendees", bundle: nil)
            
            let destinationViewController = storyboard.instantiateViewControllerWithIdentifier("SpeakerDescriptionViewController") as? SpeakerDescriptionViewController
            
            
            destinationViewController?.speaker = speakers[index-1]
            
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.exhibitors.count + self.sponsers.count + self.speakers.count
    }
    
    
    //FIXME: IMPLEMENT
    func searchPerformed() -> Bool{
        return false
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var index = indexPath.row
        
        //TODO: search must be implemented
        if searchPerformed() {
        
            
        } else {
        
            //Sponsers
            if(index >= 0 && index - 1 < atendeeControler.getSponsersCount()){
                
                if(index == 0){ // If Sponser Header
                    let cell = tableView.dequeueReusableCellWithIdentifier("sponsersHeaderCell", forIndexPath: indexPath)
                    return cell
                }
                
                let photoDetails = sponserPhotos[index-1]
                
                
                let cell = tableView.dequeueReusableCellWithIdentifier("exibitorsCell", forIndexPath: indexPath) as! AttendeesCell
                
                if photoDetails.state == PhotoRecordState.New {
                    self.startDownloadForRecord(photoDetails, indexPath: indexPath, pendingOperations: self.sponserPendingoperations)
                }
                
                let sponser = self.sponsers[index-1]
                
                cell.build(sponser)
                cell.setProfileImage(photoDetails)
                
                return cell
            }
            
            index -= atendeeControler.getSponsersCount() + 1 // Recalculates the index for exhibitors
        
            // Exhibitors
            if(index >= 0 && index - 1 < atendeeControler.getExibitorsCount()) {
            
                if(index == 0){
                    let cell = tableView.dequeueReusableCellWithIdentifier("exibitorsHeaderCell", forIndexPath: indexPath)
                    return cell
                }
                
                let photoDetails = self.exhibitorPhotos[index-1]
                
                let cell = tableView.dequeueReusableCellWithIdentifier("exibitorsCell", forIndexPath: indexPath) as! AttendeesCell
                
                if photoDetails.state == PhotoRecordState.New {
                    self.startDownloadForRecord(photoDetails, indexPath: indexPath, pendingOperations: self.exibitorPendingOperations)
                }
                
                let  exibitor = self.exhibitors[index-1]
                cell.build(exibitor)
                cell.setProfileImage(photoDetails)
    
                return cell
            }
        }
        
        index -= atendeeControler.getExibitorsCount() + 1
        
        if(index >= 0 && index - 1 < atendeeControler.getSpeakersCount()){
            if(index == 0){
                let cell = tableView.dequeueReusableCellWithIdentifier("speakersHeaderCell", forIndexPath: indexPath)
                return cell
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier("speakerCell", forIndexPath: indexPath) as! SpeakerCell
            let  speaker = atendeeControler.getSpeackerAtIndex(index - 1)
            cell.build(speaker)
        }
 
        return tableView.dequeueReusableCellWithIdentifier("exibitorsCell", forIndexPath: indexPath) as! AttendeesCell
    }
    
    @IBAction func showMenu(sender: AnyObject) {
        let rightNavController = splitViewController!.viewControllers.last as! UINavigationController
        
        rightNavController.popToRootViewControllerAnimated(true)
    }
    
    func startOperationForPhotoRecord(photoDetails: Photorecord, indexPath: NSIndexPath, pendingOperations: PendingOperarions){
        
        switch (photoDetails.state) {
        case PhotoRecordState.New:
            startDownloadForRecord(photoDetails, indexPath: indexPath, pendingOperations: pendingOperations)
            break
            
        default: print("Do Nothing..")
        }
        
    }
    
    func startDownloadForRecord(photoDetails: Photorecord, indexPath: NSIndexPath, pendingOperations: PendingOperarions){
        
        if let downloadoperarion = pendingOperations.downloadsInProgress[indexPath.row]{
            return
        }
        
        let downloader = ImageDownloader(photoRecord: photoDetails)
        
        downloader.completionBlock = {
            
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                pendingOperations.downloadsInProgress.removeValueForKey(indexPath.row)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }
        
        pendingOperations.downloadsInProgress.removeValueForKey(indexPath.row)
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}



