//    Copyright (c) 2016, Izotx
//    All rights reserved.
//
//    Redistribution and use in source and binary forms, with or without
//    modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//    * Neither the name of Izotx nor the names of its contributors may be used to
//    endorse or promote products derived from this software without specific
//    prior written permission.
//
//    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//    ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
//    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//    POSSIBILITY OF SUCH DAMAGE.

//  SponserUIViewController.swift
//  Conference App
//
//  Created by Felipe Brito {felipenevesbrito@gmail.com} on 5/24/16.
//
//

import UIKit
import Haneke

class SponserUIViewController: UIViewController {

    var sponser : Sponsor!
    var exhibitor : Exhibitor!
    
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var websiteLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        if let sponser = self.sponser{
            self.build(sponser)
        }else if let exhibitor = self.exhibitor{
            self.build(exhibitor)
        }
        
        self.UIConfig()
    }
    
    func build(exhibitor: Exhibitor){
        
        if let url = NSURL(string: exhibitor.logo) {
            self.logo.hnk_setImageFromURL(url)
        }
        
        self.nameLabel.text = exhibitor.name
        self.descriptionLabel.text = exhibitor.description
        self.websiteLabel.text = exhibitor.website
    }
    
    func build(sponsor: Sponsor){
       
        if let url = NSURL(string: sponsor.logo) {
            self.logo.hnk_setImageFromURL(url)
        }
        
        self.nameLabel.text = sponsor.name
        self.descriptionLabel.text = sponsor.description
        self.websiteLabel.text = sponsor.website
    }
    
    internal func UIConfig(){
        self.nameLabel.textColor = ItenWiredStyle.text.color.invertedColor
        self.descriptionLabel.textColor = ItenWiredStyle.text.color.invertedColor
        self.websiteLabel.textColor = ItenWiredStyle.text.color.invertedColor
        self.view.backgroundColor = ItenWiredStyle.background.color.invertedColor
    }
}

//MARK: iBeaconNearMeViewControllerProtocol
extension SponserUIViewController : iBeaconNearMeViewControllerProtocol {

    func build(with nearMeItem: iBeaconNearMeProtocol){
        
        if let s = nearMeItem as? Sponsor {
            self.sponser = s
        }
        
        if let e = nearMeItem as? Exhibitor {
            self.exhibitor = e
        }
    }
}
