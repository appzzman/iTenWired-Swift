//
//  SocialMediaData.swift
//  Conference App
//
//  Created by Christopher Rijos on 4/21/16.
//  Copyright © 2016 Chrystech Systems. All rights reserved.
//

import Foundation



class SocialMediaData {
    
    let appData = AppData()
    
    func getSocialMedia(named : String) -> SocialMedia?{
    
        
        guard let data = self.appData.getDataFromFile() else{
            return nil
        }
        
        if let socialData = data["links"] as? [NSDictionary]{
            for social in socialData {
                let dictionary = social
                let socialMedia = SocialMedia(dictionary: dictionary)
                
                if socialMedia.label == named {
                    return socialMedia
                }
            }
        }
        
       return nil
    }
    
    func getHashTags() -> [String] {
    
        guard let data = self.appData.getDataFromFile() else{
            return ["#ItenWired"]
        }
        
        if let hashTags = data["hashtags"] as? [String]{
            return hashTags
        }
        
        return ["#ItenWired"]
    }
}