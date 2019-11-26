//
//  ViewController.swift
//  mapKitWithSinglePin
//
//  Created by Lavanya on 26/11/19.
//  Copyright © 2019 Lavanya Akurathi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate{

    @IBOutlet weak var myMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func searcAction(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil
        )
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //ignore user
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //activity Indicator
        
        let activityIndictaor = UIActivityIndicatorView()
        activityIndictaor.style = .gray
        activityIndictaor.center = self.view.center
        activityIndictaor.hidesWhenStopped = true
        activityIndictaor.startAnimating()
        self.view.addSubview(activityIndictaor)
        
        //hide search bar
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //create te search request
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndictaor.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil{
                print("Error")
            }else{
                
                //Remove annotations
                
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                //getting data
                
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //create annotation
                
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                
                //Zomming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.myMapView.setRegion(region, animated: true)

                
            }
        }
        
        
    }
}

