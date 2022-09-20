//
//  ViewController.swift
//  Flix1
//
//  Created by admin on 9/12/22.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]() // creates an array of dictionary, the dictionary is declared by keyType:ValueType and the () indicates something is being intialized
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self //this calls the bottom functions
        tableView.delegate = self
    
        
//        print("hello")
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                 self.movies = dataDictionary["results"] as! [[String:Any]] //looks at the results and casts it as a dictionary of key type string and value type any
                 self.tableView.reloadData() // this function is neccessary because the table view is loaded when the app starts, but needs to be reloaded with the fresh api data
 //        print(dataDictionary)
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count // returns the amount of elements in movies
    } //This function wants a number of rows to have
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell// dequeue reusable cell recycles off screen cells so they are not all loaded all at once. needs to be cast
        //this function is called for the amount of rows

        let movie = movies[indexPath.row] // accesses each row
        let title = movie["title"] as! String //casts the title as a string
        let overview = movie["overview"] as! String
               
        cell.titleLabel.text = title //? needed because it is a swift optional
        cell.detailLabel.text = overview
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)! //a url type validates that the url is correctly formed
        
        cell.imageLabel.af.setImage(withURL: posterURL)
        
        return cell
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // "sender" is the cell that was initially sent from

        //we need to find the selected movie, so it will show on the second detail screen
        //after finding it can be passed into he detail screen
        
        let cell = sender as! UITableViewCell  // sets cell as the selected cell 
        let indexPath = tableView.indexPath(for:cell)! //this provides the specific indexPath, or index, for a given cell. Since the cell we clicked on is the sender, if we pass in the sender, then we can be given the index path back to find the specific data point
        let movie = movies[indexPath.row] //finds the specific movie

        let detailsViewController = segue.destination as! MoviesDetailViewController //takes a generic viewcontroller and casts it as movie details view controller
        detailsViewController.movie = movie // passes movie dictionary to details view controller
        
        
        tableView.deselectRow(at: indexPath, animated: true) //this will deselect the previously selected movie so it isn't highlighted when we come back
        
        

    }
}

