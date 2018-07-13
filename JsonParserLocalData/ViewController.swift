//
//  ViewController.swift
//  JsonParserLocalData
//
//  Created by PASHA on 12/07/18.
//  Copyright © 2018 Pasha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var names = [String]()
    
    @IBOutlet weak var myTB: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  jsonParser()
        
        getLocalData { (success, response, error) in
            
            if success
            {
                guard let names = response as? [String] else { return }
                self.names = names
                self.myTB.reloadData()
            }
            else if  let error = error
            {
                print(error)
            }
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func jsonParser() {
        
 guard let path = Bundle.main.path(forResource:"usersAPI", ofType:"txt") else { return}
        
    let url = URL(fileURLWithPath: path)
        
        do {
            
            let data = try Data(contentsOf: url)
           let jsonData = try JSONSerialization.jsonObject(with:data, options:.mutableContainers)
            
            print(jsonData)
            
            guard let dataArr = jsonData as? [Any] else { return }
             print("data count is : \(dataArr[0])")
            
            
            
            
            for user in dataArr {
                
                guard let userDict = user as? [String: Any] else { return }
                
             guard let company = userDict["company"] as? [String: Any] else { return }
                
              guard let bs = company["bs"] as? String else { return }
                
                  guard let id = userDict["id"] as? Int else { return }
                  guard let name = userDict["name"] as? String else { return }
                  guard let website = userDict["website"] as? String else { return }
                print("\n ID : \(id) " + "\n Name : \(name)" + "\n website : \(website)" + "\n bs is : \(bs)")
                
            }
            
           
          }
        
        catch {
         print("error occured")
        }
    
        
    }
    
    func getLocalData(completion: @escaping (Bool, Any?, Error?) -> Void) {
        
        DispatchQueue.global().asyncAfter(deadline: .now()+3) {
            
            guard let path = Bundle.main.path(forResource: "usersAPI", ofType: "txt") else { return }
            let url = URL(fileURLWithPath: path)
            
            do {
                let data = try Data(contentsOf: url)
                let jsonData = try JSONSerialization.jsonObject(with: data, options:.mutableContainers)
                
                guard let myArr = jsonData as? [Any] else { return }
                
                var names = [String]()
                for user in myArr {
                    
                    guard let userDict = user as? [String : Any] else {return}
                    
                    guard let name = userDict["name"] as? String else { return }
                  //  print("Name is : ------ \(name)")
                    
                    names.append(name)
                }
                
                DispatchQueue.main.async {
                    
                     completion(true,names,nil)
                }
               
                
                
            } catch  {
                  print(error)
                DispatchQueue.main.async {
                    
                  completion(false,nil,error)
                }
              
                
            }
            
            
        }
     
        
       
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "\(self.names[indexPath.row])"
        return cell
    }
    
    
    
}
