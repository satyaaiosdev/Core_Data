//
//  ViewController.swift
//  Core
//
//  Created by Satyaa Akana on 21/06/20.
//  Copyright © 2020 Satyaa Akana. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var tabView: UITableView!
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let request:NSFetchRequest<Student> = Student.fetchRequest()
    
    var studentArray = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idTF.delegate = self
        nameTF.delegate = self
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        fetchItems()
    }

    @IBAction func addButton(_ sender: UIButton) {
        let newItem = Student(context: self.context!)
        
        newItem.name = nameTF.text!
        newItem.id = idTF.text!
        
        self.studentArray.append(newItem)
        saveItem()
        
       }
    @IBAction func upDateButton(_ sender: UIButton) {
        self.update()
       }
    @IBAction func deleteButton(_ sender: UIButton) {
        self.delete()
       }
    @IBAction func retriveButton(_ sender: UIButton) {
        self.fetchItems()
       }
    
    func fetchItems(){
            
            do{
                studentArray = try (context?.fetch(self.request))!
            }catch{
                
            }
        }
    func saveItem(){
        do{
            try context!.save()
            print("Saved one context")
            tabView.reloadData()
        }catch{
            print(error.localizedDescription)
        }
    }
    func update(){
        do{
            studentArray = try (context?.fetch(self.request))!
            
            studentArray[2].setValue(idTF.text!, forKey: "id")
            
            studentArray[2].name = nameTF.text!
            
            //studentArray[2].setValue(nameTF.text!, forKey: "name")
            saveItem()
        }catch{
            
        }
    }
    func delete(){
               
               do{
                   studentArray = try (context?.fetch(self.request))!
                   context?.delete(studentArray[2])
                   saveItem()
               }catch{
                   
               }
           }
    
}


extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tabView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell
        cell?.idLabel.text = studentArray[indexPath.row].id
        cell?.nameLabel.text = studentArray[indexPath.row].name
        return cell!
    }
}
