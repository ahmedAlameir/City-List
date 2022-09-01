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
    var num = 1
    @IBOutlet weak var citiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //DataManager.sharedInstance.deleatAll()
        self.citiesTableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        if DataManager.sharedInstance.retrieveSavedUsers(from: 0, to: 50)!.count == 0{
            fatchResponse()
        }
        else{
            self.cities=DataManager.sharedInstance.retrieveSavedUsers(from: 0, to: 50)!
            self.citiesTableView.reloadData()
        }
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
                    DataManager.sharedInstance.saveUserData(response)
                    self.num += 1
                    print(self.num)
                    if ((response.count) > 0) {
                        self.fatchResponse()
                    }else{
                        self.cities=DataManager.sharedInstance.retrieveSavedUsers(from: 0, to: 50)!
                        self.citiesTableView.reloadData()
                    }
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
            networkServices.fetchMap (coord: filterCitis[indexPath.row].coord, complation:{ result in
                switch result
                {
                case .success(let response):
                    DispatchQueue.main.async {
                        guard let response = response else {return}
                        cell.mapImage.image = response
                    }

                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }else{
            cell.cityName.text = cities[indexPath.row].name
            networkServices.fetchMap (coord: cities[indexPath.row].coord, complation:{ result in
                switch result
                {
                case .success(let response):
                    DispatchQueue.main.async {
                        guard let response = response else {return}
                        cell.mapImage.image = response
                    }

                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
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
                cities.append(contentsOf: DataManager.sharedInstance.retrieveSavedUsers(from: cities.count, to: cities.count+10)!)
                citiesTableView.reloadData()
                fatchFilterdCitiys()
            }
            
        }else{
        let lastElement = cities.count-10
        if lastElement == indexPath.row{
            num += 1
            cities.append(contentsOf: DataManager.sharedInstance.retrieveSavedUsers(from: cities.count, to: cities.count+10)!)
            citiesTableView.reloadData()
            print(1)
             
        }
       }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        if searchFilter == true{
            mapVC.coord = filterCitis[indexPath.row].coord
            mapVC.cityName=filterCitis[indexPath.row].name
        }else{
            mapVC.coord = cities[indexPath.row].coord
            mapVC.cityName=cities[indexPath.row].name
        }
        self.navigationController?.pushViewController(mapVC, animated: true)

    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = citiesTableView.cellForRow(at: indexPath) as! CityTableViewCell
        cell.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = citiesTableView.cellForRow(at: indexPath) as! CityTableViewCell
        cell.backgroundColor = UIColor(red: 1, green: 1, blue:1, alpha: 1)
    }
}
extension CitiesListViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        if searchText.isEmpty{
            searchFilter = false
            
            filterCitis.removeAll()
            citiesTableView.reloadData()
        }else{
            searchFilter = true
            fatchFilterdCitiys()
        }
    }
}

