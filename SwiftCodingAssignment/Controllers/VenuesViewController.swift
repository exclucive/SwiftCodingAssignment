//
//  ViewController.swift
//
//  Created by Igor Novik on 2018-03-19.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit
import Kingfisher

class VenuesViewController: UIViewController {
    static let minimumWordLenth = 3
    static let coordinates = "37.7749,-122.4194"
    
    // data
    var venues: [Venue] = []
    
    // UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Helpers
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func fetchPlacesWith(name: String) {
        guard let queryTerm = self.searchBar.text,
                  queryTerm.count >= VenuesViewController.minimumWordLenth else {
            return
        }
        activityIndicator.startAnimating()
        self.tableView.isHidden = true
        
        PlacesFetcher.requestVenues(term: queryTerm,
                                    coordinates: VenuesViewController.coordinates) { (venues, error) in
            guard error == nil else {
                // TODO: handle error
                return
            }
            
            guard let venues = venues  else { return }
            self.venues = venues
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.activityIndicator.stopAnimating()
        }
    }
}

extension VenuesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configure(cell: VenueTableViewCell, indexPath: IndexPath) {
        let venue = self.venues[indexPath.row]
        
        //
        let url = venue.getIconURLForSize(.big)
        cell.venueIconImageView?.kf.setImage(with: url)
        
        //
        cell.venueNameLabel.text = venue.name
        
        var address = ""
        for addressLine in venue.location.formattedAddress {
            address += addressLine + ", "
        }
        address = String(address.dropLast(2))
        
        cell.venueAddressLabel.text = address
        cell.venueDistanceLabel.text = "\(venue.location.distance)m"
        cell.venuePhoneLabel.text = venue.contact?.formattedPhone ?? "-- no phone number --"
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        guard let venueCell = tableView.dequeueReusableCell(withIdentifier: VenueTableViewCell.cellIdentifier, for: indexPath) as? VenueTableViewCell else {
            return cell
        }
        
        //
        configure(cell: venueCell, indexPath: indexPath)
        
        return venueCell
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension VenuesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                            textDidChange searchText: String) {
        fetchPlacesWith(name: searchText)
        
        if searchText.count >= VenuesViewController.minimumWordLenth {
            placeholderLabel.isHidden = true
        }
    }
}

