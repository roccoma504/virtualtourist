//
//  NetworkingOps.swift
//  virtualtourist
//
//  Created by Matthew Rocco on 12/7/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation


class NetworkingOps {
    
    var lat : Double
    var long : Double
    
    init(lat : Double, long : Double){
        self.lat = lat
        self.long = long
    }
    
    
    func getFlikrPhoto() {
        
        let BASE_URL = "https://api.flickr.com/services/rest/"
        
        /* 2 - API method arguments */
        let methodArguments = [
            "method": "flickr.photos.search",
            "api_key": KEY,
            "extras": "url_m",
            "format": "json",
            "nojsoncallback": "1",
            "lat": String(lat),
            "lon": String(long)
        ]
        
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        print(urlString)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            guard let statusCode = (
                response as? NSHTTPURLResponse)?.statusCode where
                statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(
                    data, options: .AllowFragments)
                print(parsedResult)
                print("parsed right")
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
        }
        task.resume()
    }
    
    
    
    /** Helper function: Given a dictionary of parameters, convert to a string for a url
    - Parameters:
        - parameters: - the dictionary that needs to be escaped
    - Returns: the escaped string
    */
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        for (key, value) in parameters {
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(
                NSCharacterSet.URLQueryAllowedCharacterSet())
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
}