



import UIKit
class SongClass: UIViewController, UISearchBarDelegate {
    var searchNames = [String]()
    //    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var songView: UITableView!
    var songData = [TrackList](){
        didSet {
            DispatchQueue.main.async
                {
                    self.songView.reloadData()
            }
        }
    }
    var searchResults = [Track]()
    let searchController = UISearchController(searchResultsController: nil)





    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()

        // Do any additional setup after loading the view.
    }
    func setup() {
        songView.dataSource = self as! UITableViewDataSource
        songView.delegate = self as! UITableViewDelegate
        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Contacts"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    func fetchData() {
        SongAPIClient.shared.getSong { (result) in
            switch result {
            case .failure(let error):
                print("Error Code: \(error)")
            case .success(let contact):
                self.songData = contact
            }
        }
    }

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchResults = songData.filter({( result : Track) -> Bool in
            return result.artist_name
        })

        songView.reloadData()
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}


extension SongClass: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    // MARK: - UISearchResultsUpdating Delegate

}
extension SongClass: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return searchResults.count
        }

        return songData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath)
        let result: TrackList
        if isFiltering() {
            result = searchResults[indexPath.row]
        } else {
            result = songData[indexPath.row]
        }
        cell.textLabel!.text = result.artist_name
        cell.detailTextLabel!.text = result.track_name
        return cell
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("Segue works")
//        if segue.identifier == "showDetail" {
//            if let indexPath = songView.indexPathForSelectedRow {
//                let result: Results
//                if isFiltering() {
//                    result = searchResults[indexPath.row]
//                } else {
//                    result = songData[indexPath.row]
//                }
//                let controller = (segue.destination as! ContactsDetailViewController)
//                controller.detailResult = result
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }


}
