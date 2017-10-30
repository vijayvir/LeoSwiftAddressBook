//
//  LeoSwiftAddressBook.swift
//  LeoContractBook
//
//  Created by vijay vir on 10/27/17.
//  Copyright © 2017 vijay vir. All rights reserved.
//
//https://github.com/SocialbitGmbH/SwiftAddressBook
//https://stackoverflow.com/questions/28087688/alphabetical-sections-in-table-table-view-in-swift
import Foundation
import SwiftAddressBook

// Add this line to project pList to access contact with user  permisssions.
/*
<key>NSContactsUsageDescription</key>
<string>This app requires contacts access to function properly.</string>
<key>NSContactsUsageDescription </key>
<string>This app requires contacts access to function properly.</string>

*/
func leoSwiftAddressBookOpenSettings() {
	UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:]) { (isSucess) in
	}
}

func leoSwiftAddressBookRequestAccess(_ completionHandler : @escaping (Bool) -> Void )  {
	SwiftAddressBook.requestAccessWithCompletion({ (success, error) -> Void in
	 completionHandler (success)
		if success {
						print("🔐", success )
			//do something with swiftAddressBook
		}
		else {
				print("🔒", success )
			//no success. Optionally evaluate error
		}
	})
}


func leoSwiftAddressBookAllPeople(searchText : String ) ->  [[String: [SwiftAddressBookPerson]]] {

	let people =  leoSwiftAddressBookAllPeople()


	let  filterArrayPeople =  people.filter { (person) -> Bool in

		if  person.firstName?.lowercased().range(of:searchText) != nil  || person.lastName?.lowercased().range(of:searchText) != nil {

			// TODO : Phone number

			return true
		}
		return false
	}
	let indexes : [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z" ,"#"]
	var returnPeople : [ [String: [SwiftAddressBookPerson] ]] = []

	for  (_,charater) in indexes.enumerated() {

		let filterArray =  filterArrayPeople.filter { (person) -> Bool in
			if (person.firstName?.lowercased().hasPrefix(charater.lowercased()))! {
				return  true
			}

			if charater == "#" {

				if (person.firstName != nil) {
					if  person.firstName!.count > 0 {
						if let firstName = person.firstName {
							if !("\(Array(firstName)[0])" =^ LeoRegex.LeoRegexType.alphabets.pattern) {
								return true
							}
						}
					}
				}


			} 

			return false
		}

		if filterArray.count > 0 {
			let some : [String: [SwiftAddressBookPerson]] = [charater : filterArray ]
			returnPeople.append(some)
		}

	}
	return returnPeople

}




func leoSwiftAddressBookAllPeople( ) -> [SwiftAddressBookPerson]  {

	if let people = swiftAddressBook?.allPeople {
     return people
	}
    return []
}



func leoSwiftAddressBookAllPeopleWithIndexes( ) ->  [[String: [SwiftAddressBookPerson]]]  {

	 let indexes : [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z" ,"#"]
	var returnPeople : [ [String: [SwiftAddressBookPerson] ]] = []

	if let people = swiftAddressBook?.allPeople {

		for  (_,charater) in indexes.enumerated() {

			let filterArray =  people.filter { (person) -> Bool in
				if (person.firstName?.lowercased().hasPrefix(charater.lowercased()))! {
							return  true
				}

				if charater == "#" {

					if (person.firstName != nil) {
						if  person.firstName!.count > 0 {
							if let firstName = person.firstName {
								if !("\(Array(firstName)[0])" =^ LeoRegex.LeoRegexType.alphabets.pattern) {
									return true
								}
							}
						}
					}


					 }

				return false
			}
			if filterArray.count > 0 {
				let some : [String: [SwiftAddressBookPerson]] = [charater : filterArray ]
				returnPeople.append(some)
			}
		}
 return returnPeople

	}
	return returnPeople
}

class LeoSwiftAddressBookO: NSObject {

	@IBOutlet weak var tableView: UITableView!

	@IBOutlet weak var searchBar: UISearchBar!

	var people :  [[String: [SwiftAddressBookPerson]]]  = []

	var filterPeople : [[String: [SwiftAddressBookPerson]]] = []
}

extension LeoSwiftAddressBookO : UITableViewDataSource {

	func configure() {

		searchBar.text = ""

		leoSwiftAddressBookRequestAccess({ isAllowed in
			if isAllowed {

				DispatchQueue.main.async {
					let people = leoSwiftAddressBookAllPeopleWithIndexes()

					
					self.people = people
					self.tableView.reloadData()
				}
			} else {
				leoSwiftAddressBookOpenSettings()
			}
		})
	}
	func numberOfSections(in tableView: UITableView) -> Int {

		if searchBar.text!.count > 0 {
    return  filterPeople.count
		}

		return people.count

	}
	 func sectionIndexTitles(for tableView: UITableView) -> [String]? {

   if searchBar.text!.count > 0 {
	let sectionIndexTitles  = filterPeople.map { ( some : [String: [SwiftAddressBookPerson]]) -> String in

		return some.keys.first!
	}
   	return sectionIndexTitles

		}
		let sectionIndexTitles  = people.map { ( some : [String: [SwiftAddressBookPerson]]) -> String in

			  return some.keys.first!
		}


		return sectionIndexTitles

	}
	 func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		return index
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

		if searchBar.text!.count > 0 {

			if let group = filterPeople[section] as? [String: [SwiftAddressBookPerson]] {
				return group.keys.first
			}
		}


		if let group = people[section] as? [String: [SwiftAddressBookPerson]] {
         return group.keys.first
		}
		return "**"
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchBar.text!.count > 0 {
			if let group = filterPeople[section] as? [String: [SwiftAddressBookPerson]] {
				return group[group.keys.first!]!.count
			}
		}

		if let group = people[section] as? [String: [SwiftAddressBookPerson]] {
			return group[group.keys.first!]!.count
		}

		return 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

		let cell : LeoSwiftAddressBookTableViewCell = tableView.dequeueReusableCell(withIdentifier: LeoSwiftAddressBookTableViewCell.identifier) as! LeoSwiftAddressBookTableViewCell
		 	if searchBar.text!.count > 0  {



				if let group = filterPeople[indexPath.section] as? [String: [SwiftAddressBookPerson]] {

					cell.configure(person: group[group.keys.first!]![indexPath.row])

				}

			} else {

				if let group = people[indexPath.section] as? [String: [SwiftAddressBookPerson]] {

					cell.configure(person: group[group.keys.first!]![indexPath.row])

				}
		}


		return  cell
	}
}
extension LeoSwiftAddressBookO : UITableViewDelegate  {

}
extension LeoSwiftAddressBookO : UISearchBarDelegate {

	func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
   return true
}

	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

	}
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { // called when text changes (including clear)
		  textDidChange(searchText : searchText.lowercased())
	}
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		// called when keyboard search button pressed
		searchBar.resignFirstResponder()

	}
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
	}

	func textDidChange(searchText: String){

		self.filterPeople =  leoSwiftAddressBookAllPeople(searchText: searchText)

		tableView.reloadData()

	}
}

class LeoSwiftAddressBookTableViewCell : UITableViewCell {

	static let  identifier : String = "LeoSwiftAddressBookTableViewCell"

	@IBOutlet weak var lblName: UILabel!

	@IBOutlet weak var lblPhoneNumber: UILabel!

	var person : SwiftAddressBookPerson?

	func configure( person : SwiftAddressBookPerson) {

   self.person = person

		lblName.text = person.firstName

	  lblPhoneNumber.text = " \(person.lastName ?? "" ) ,\(person.phoneNumbers?.count)"

	}
}

