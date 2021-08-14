//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Noor Mohammed Anik on 14/8/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
       
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
        
    }()
    
    private var models = [ToDoListItems]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Core Data To Do List"
        view.addSubview(tableView)
        
        getAllItems()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem (barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        //when click + add button,then didTapAdd function call
    }
    
    @objc private func didTapAdd() {
        
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
        
        //for adding text field in alert dialog
        alert.addTextField(configurationHandler: nil)
        
       //when click submit then its execute
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {[weak self] _ in
            
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                
                return
                
            }
            
            self?.createItem(name: text)
        }))
        present(alert, animated: true)
    }
    
    
    //for count num of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    
    //set data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        
       // cell.textLabel?.text = model.createdAt
        return cell
    }
    
    
    //select cell or tap
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        
      //  sheet.addTextField(configurationHandler: nil)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default , handler: { _ in
            
       
            
            let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: {[weak self] _ in
                
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    
                    return
                    
                }
                
                self?.updateItem(item: item, newName: newName)
            }))
            self.present(alert, animated: true)
            
        
        }))
        
        
        
        //for delete data
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {  [weak self] _ in
            self?.deleteItem(item: item)
        }))
      
        present(sheet, animated: true)
        
    }
    
    //core data
    func getAllItems(){
        do {
         models = try  context.fetch(ToDoListItems.fetchRequest())
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        
        }
        catch {
            //error
        }
        
    }

    func createItem(name: String)
    {
        
        let newItem = ToDoListItems(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do {
            try context.save()
            
            getAllItems()
        }
        
        catch
        {
           //handle error
        }
        
        
    }
    
    func deleteItem(item: ToDoListItems) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        }
        
        catch
        {
           //handle error
        }
       
        
    }
    
    func updateItem(item: ToDoListItems, newName: String)
    {
        item.name = newName
        
        do {
            try context.save()
            
            getAllItems()
        }
        
        catch
        {
           //handle error
        }
       
    }

}

