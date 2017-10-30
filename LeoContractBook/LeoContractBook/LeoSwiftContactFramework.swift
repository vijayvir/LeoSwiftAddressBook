////
////  LeoSwiftContactFramework.swift
////  LeoContractBook
////
////  Created by vijay vir on 10/27/17.
////  Copyright © 2017 vijay vir. All rights reserved.
////
//
//import UIKit
//import Contacts
//
//
//public enum Result<T, error: Error> {
//	case Success(T)
//	case Failure(ContactsError)
//}
//
//public enum ContactsError: Error {
//	case ContactsAccessDenied(message : String)
//	case OtherError(code: Int)
//	case UnexpectedError(message: String)
//
//}
//
//private let _сontactsManagerSharedInstance = ContactsManager()
//
//class ContactsManager: NSObject {
//
//	var contactStore = CNContactStore()
//
//	class var sharedInstance: ContactsManager {
//		return _сontactsManagerSharedInstance
//	}
//
//	func requestForAccess(completionHandler: @escaping (Result<Bool, NSError>) -> Void) {
//		let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
//
//		switch authorizationStatus {
//		case .authorized:
//			completionHandler(Result.Success(true))
//		case .denied, .notDetermined:
//			self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
//				if access {
//					completionHandler(Result.Success(true))
//				}
//				else {
//					if authorizationStatus == CNAuthorizationStatus.denied {
//						dispatch_async(dispatch_get_main_queue(), { () -> Void in
//							let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
//							completionHandler(Result.Failure(.ContactsAccessDenied(message: message)))
//
//						})
//					}
//				}
//			})
//
//		default:
//			completionHandler(Result.Success(true))
//		}
//	}
//
//
//	func findContact(firstName : String, lastnName : String) -> CNContact?
//	{
//		let toFetch = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNameSuffixKey]
//		let predicate = CNContact.predicateForContacts(matchingName: firstName + " " + lastnName)
//
//		var returnContact : CNContact? = nil
//
//		do{
//			let contacts = try self.contactStore.unifiedContacts(matching: predicate, keysToFetch: toFetch as [CNKeyDescriptor])
//			for contact in contacts
//			{
//				if contact.nameSuffix == "via Main"
//				{
//					returnContact = contact
//					break
//				}
//			}
//		} catch let err{
//			print(err)
//			return nil
//		}
//
//		return returnContact
//	}
//
//	func createGroup() -> CNGroup?
//	{
//		do{
//
//			let groups = try self.contactStore.groups(matching: nil)
//			let filteredGroups = groups.filter { $0.name == "Main Contacts" }
//
//			if filteredGroups.count > 0
//			{
//				return filteredGroups[0]
//			}
//
//			let newGroup = CNMutableGroup();
//			let saveRequest = CNSaveRequest()
//			newGroup.name = "Main Contacts"
//			saveRequest.add(newGroup, toContainerWithIdentifier: nil)
//			do{
//				try self.contactStore.execute(saveRequest)
//				print("Successfully added the group")
//
//				return newGroup
//			} catch let err{
//				print("Failed to create the group. \(err)")
//
//				return nil
//			}
//		}
//		catch _
//		{
//			return nil
//		}
//
//
//	}
//
//	func loadAllContacts() -> [NSDictionary]
//	{
//		var contactsArray : [NSDictionary] = []
//		let keysToFetch = [
//			CNContactFamilyNameKey,
//			CNContactGivenNameKey,
//			CNContactEmailAddressesKey,
//			CNContactPhoneNumbersKey,
//			CNContactThumbnailImageDataKey,
//			CNContactNameSuffixKey]
//
//		// Get all the containers
//		var allContainers: [CNContainer] = []
//		do {
//			allContainers = try contactStore.containers(matching: nil)
//		} catch {
//			print("Error fetching containers")
//		}
//
//		var results: [CNContact] = []
//
//		// Iterate all containers and append their contacts to our results array
//		for container in allContainers {
//			let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
//
//			do {
//				let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
//				results.appendContentsOf(containerResults)
//			} catch {
//				print("Error fetching results for container")
//			}
//		}
//
//
//
//		for contact in results {
//
//			if contact.familyName.lengthOfBytes(using: String.Encoding.utf8) > 0 && contact.givenName.lengthOfBytes(using: String.Encoding.utf8)  > 0 && contact.phoneNumbers.count > 0
//			{
//
//				var phonesArray  = Array<Dictionary<String,String>>()
//				for plabel in contact.phoneNumbers {
//					let number  = plabel.value as! CNPhoneNumber
//					let label :String  =  CNLabeledValue.localizedStringForLabel(plabel.label !)
//
//					let phone = ["label" : label, "phone" : number.stringValue]
//					phonesArray.append(phone)
//				}
//
//
//				var emailsArray  = Array<Dictionary<String,String>>()
//				for plabel in contact.emailAddresses {
//					print(plabel.label ?? "")
//					let eLabel = plabel.label //_$!<Work>!$_
//					var emailLabel = "Work"
//					if eLabel?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
//					{
//						let eLabel2 = eLabel.characters.split("<").map(String.init) //[_$!<, Work>!$_]
//						let eLabel3 = eLabel2[1].characters.split(">").map(String.init) //[Work, >!$_]
//						emailLabel = eLabel3[0] //Work
//					}
//
//					let email = plabel.value
//					let emailDict = ["label" : emailLabel, "email" : "\(email)" ]
//					emailsArray.append(emailDict)
//				}
//
//				let person = ["firstname": contact.givenName, "lastname": contact.familyName, "phones" : phonesArray, "emails" : emailsArray, "suffix" : contact.nameSuffix] as [String : Any] as [String : Any]
//				contactsArray.append(person)
//			}
//
//
//
//		}
//		print("contacts count \(contactsArray.count)")
//
//		print("contacts  \(contactsArray)")
//
//		return contactsArray
//	}
//
//	func deleteAllContacts()
//	{
//
//		do{
//
//			let groups = try self.contactStore.groupsMatchingPredicate(nil)
//			let filteredGroups = groups.filter { $0.name == "Main Contacts" }
//
//			if filteredGroups.count > 0
//			{
//
//				let predicate = CNContact.predicateForContactsInGroupWithIdentifier(filteredGroups.first!.identifier)
//				let keysToFetch = [CNContactGivenNameKey]
//				let contacts = try self.contactStore.unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
//
//				for contact in contacts
//				{
//					self.deleteContact(contact)
//				}
//
//				let saveRequest = CNSaveRequest()
//				saveRequest.deleteGroup(filteredGroups.first!.mutableCopy() as! CNMutableGroup)
//				do {
//					try contactStore.executeSaveRequest(saveRequest)
//				}
//				catch {
//					print("error while deleting group")
//				}
//			}
//
//
//		}
//		catch _
//		{
//			print("error while deleting group")
//		}
//
//
//
//
//	}
//
//	func deleteContact(contact : CNContact) -> Bool
//	{
//		let req = CNSaveRequest()
//		let mutableContact = contact.mutableCopy() as! CNMutableContact
//		req.deleteContact(mutableContact)
//
//		do{
//			try self.contactStore.executeSaveRequest(req)
//			print("Success, You deleted the user")
//			return true
//		} catch let e{
//			print("Error = \(e)")
//			return false
//		}
//	}
//
//	func createContact(person : MainContact)
//	{
//		if !appDelegate.normalExecutionPath() {
//			return
//		}
//
//		if let c = self.findContact(person.firstname, lastnName: person.lastname)
//		{
//			self.deleteContact(c)
//		}
//
//
//		if let group = self.createGroup()
//		{
//			let contactData = CNMutableContact()
//
//			var profType : ProfileType = ProfileType.Basic
//			if let shared = person.profileType
//			{
//				if shared == "Business"
//				{
//					profType = ProfileType.Business
//				}
//				if shared == "Social"
//				{
//					profType = ProfileType.Social
//				}
//			}
//
//			contactData.givenName = person.firstname
//			contactData.familyName = person.lastname
//			contactData.nameSuffix = "via Main"
//
//			let phones = helper.phonesForUserAndProfileType(person, profile: profType)
//			if(phones?.count > 0)
//			{
//				let phonesArray : [Phones] = phones!
//				var phonesToAdd = [CNLabeledValue]()
//				for phone in phonesArray
//				{
//					if let phoneT = phone.phoneType
//					{
//						if phoneT.lowercaseString == "mobile"
//						{
//							let mobilePhone = CNLabeledValue(label: "mobile",value: CNPhoneNumber(stringValue: phone.phone))
//							phonesToAdd.append(mobilePhone)
//						}
//						if phoneT.lowercaseString == "landline"
//						{
//							let landlinePhone = CNLabeledValue(label: "landline",value: CNPhoneNumber(stringValue: phone.phone))
//							phonesToAdd.append(landlinePhone)
//						}
//					}
//				}
//				contactData.phoneNumbers = phonesToAdd
//			}
//
//			let emails = helper.emailsForUserAndProfileType(person, profile: profType)
//			if(emails?.count > 0)
//			{
//				let emailsArray : [Emails] = emails!
//				var emailsToAdd = [CNLabeledValue]()
//				for email in emailsArray
//				{
//					if(email.email != nil)
//					{
//						let em = CNLabeledValue(label: email.emailType == nil ? CNLabelWork : email.emailType, value: email.email)
//						emailsToAdd.append(em)
//					}
//				}
//				contactData.emailAddresses = emailsToAdd
//			}
//
//
//			let request = CNSaveRequest()
//			request.add(contactData, toContainerWithIdentifier: nil)
//			request.addMember(contactData, to: group)
//			do{
//				try self.contactStore.execute(request)
//				print("Successfully added the contact")
//			} catch let err{
//				print("Failed to save the contact. \(err)")
//			}
//		}
//
//
//	}
//
//}

