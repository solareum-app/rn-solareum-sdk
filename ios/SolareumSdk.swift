

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
    func open(_ payment: NSString) -> Void{
        var dictionary:NSDictionary?
            
        if let data = payment.data(using: String.Encoding.utf8.rawValue) {
                
             do {
               dictionary =  try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String:AnyObject] as NSDictionary?
                
                    if let paymentDictionary = dictionary
                      {
                        let address = paymentDictionary["address"]
                        let token = paymentDictionary["token"]
                        let scheme = paymentDictionary["scheme"]
                        let client_id = paymentDictionary["client_id"]

                      let urlScheme = externalURLScheme()
                      if  let solareumUrl = URL(string:"solareum://app?address=\(address!)&token=\(token!)&client_id=\(client_id!)&scheme=\(urlScheme!)"){
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
                                        let universalLink = URL(string: "https://solareum.page.link/rewards?address=\(address!)&token=\(token!)")
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
                    } catch let error as NSError {
                    
                    print(error)
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

