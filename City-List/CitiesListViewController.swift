//
//  CitiesListViewController.swift
//  city-list
//
//  Created by ahmed osama on 29/08/2022.
//

import UIKit

class CitiesListViewController: UIViewController {

    var searchFilter = false
    var searchText = ""
    var filterCitis = [Cities]()
    let networkServices = NetworkServices()
    var cities = [Cities]()
    var num = Int()
    @IBOutlet weak var citiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fatchResponse()
        citiesTableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "CityTableViewCell")

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func fatchResponse(){
        networkServices.fetchCities(pageNum: num, complation:{ result in
            switch result
            {
            case .success(let response):
                DispatchQueue.main.async {
                    guard let response = response else {return}
                    self.cities.append(contentsOf: response)
                    self.citiesTableView.reloadData()
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
    }
    func fatchFilterdCitiys(){
        filterCitis=cities.filter({city -> Bool in
            return city.name.range(of: searchText, options: .caseInsensitive) != nil
        })
        citiesTableView.reloadData()
    }
    

}
extension CitiesListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchFilter == true{
        return filterCitis.count
        }else{
            return cities.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = citiesTableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
        if searchFilter == true{
            cell.cityName.text = filterCitis[indexPath.row].name

        }else{
            cell.cityName.text = cities[indexPath.row].name
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchFilter == true{
            let lastElement = filterCitis.count-1
            if lastElement == indexPath.row{
                num += 1
                fatchResponse()
                fatchFilterdCitiys()
            }
            
        }else{
        let lastElement = cities.count-1
        if lastElement == indexPath.row{
            num += 1
            print(DataManager.sharedInstance.retrieveSavedUsers()!)
            fatchResponse()
        }
       }
    }
}
extension CitiesListViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        if searchText.isEmpty{
            searchFilter = false
            filterCitis.removeAll()
        }else{
            searchFilter = true
            fatchFilterdCitiys()
        }
      

    }
}
