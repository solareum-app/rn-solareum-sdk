

import Foundation
import UIKit

@objc(SolareumSdk)
class SolareumSdk: NSObject {
    override init() {
        super.init()
}
    
  static func moduleName() -> String! {
    return "SolareumSdk"
  }
  
  static func requiresMainQueueSetup () -> Bool {
     return true;
   }
    
 
 @objc
  func open() -> Void{
      let urlScheme = externalURLScheme();
    if  let solareumUrl = URL(string:"solareum://app?address=D4aw7jPLJLEXqmKf9nQfMCbevtuVX4b1PkuKx5p2H1jx&token=XSB&scheme=\(urlScheme!)"){
      DispatchQueue.main.async {
          if #available(iOS 10.0, *) {
              UIApplication.shared.open(solareumUrl, options: [:], completionHandler: {
                  (success) in
                  if (success)
                  {
                      print("OPENED \(solareumUrl): \(success)")
                  }
                  else
                  {
                      let universalLink = URL(string: "https://solareum.page.link/rewards?address=D4aw7jPLJLEXqmKf9nQfMCbevtuVX4b1PkuKx5p2H1jx&token=XSB")
                      UIApplication.shared.open(universalLink!, options: [:], completionHandler: {
                          (success) in
                          if (success)
                          {
                              print("OPENED \(String(describing: universalLink)): \(success)")
                          }
                          else
                          {
                              
                          }
                      })
                  }
              })
          } else {
              // Fallback on earlier versions
          }
      }
    }
  }
    
func externalURLScheme() -> String? {
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [AnyObject],
              let urlTypeDictionary = urlTypes.first as? [String: AnyObject],
              let urlSchemes = urlTypeDictionary["CFBundleURLSchemes"] as? [AnyObject],
              let externalURLScheme = urlSchemes.first as? String else { return nil }
        
        return externalURLScheme
    }

}

