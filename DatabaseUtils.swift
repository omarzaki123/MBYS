//
//  DatabaseUtils.swift 
//  Mesh
//
//  Created by Paa Adu on 8/2/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import Firebase
import FirebaseStorage

let storageBucket = "gs://meshtest-184f5.appspot.com"
let MAX_FILE_SIZE = 10 * 1024 * 1024 //10 MB. This ensures a user doesn't try to upload some random huge file.

enum TypeOfPost {
    case Text
    case Image
    case School
}

//Save information about the current user
func saveProfile(user: User, callback: (NSError?) -> Void) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let profile = ["firstName": user.firstName,
                       "lastName": user.lastName,
                       "secondaryEmail": user.secondaryEmail,
                       "company": user.company,
                       "school": user.school,
                       "position": user.position,
                        "phoneNumber": user.phoneNumber] // ******change later******
        ref.child("users/\(userID)/profile").setValue(profile, withCompletionBlock: { (error, firebaseReference) in
            callback(error)
        })
        if(user.school != "") {
            ref.child("schools/\(user.school)").child(userID).setValue(true)
        }
        
    }
}

// Add favorite for current user
func addFavorite(user: User) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let favorite = ["id": user.userId]
        ref.child("users/\(userID)/favorites").childByAutoId().setValue(favorite)
    }
}

// Remove favorite for current user
func removeFavorite(user: User) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        ref.child("users/\(userID)/favorites").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                if let id = childSnapshot.value?["id"] as? String {
                    if id == user.userId {
                        childSnapshot.ref.removeValue()
                    }
                }
            }
        })
    }
}

// Gets favorites for current user
func getFavorites(callback: ([String]) -> Void) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        ref.child("users/\(userID)/favorites").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            var users = [String]()
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                if let id = childSnapshot.value?["id"] as? String {
                    users.append(id)
                }
            }
            callback(users);
        })
    }
}

//Returns bool based on whether current account is a Master Account

/*Asynchronous funch that returns bool based on whether current account is a Tech Account
 isMasterAccount() { (isMasterAccount) in
 if(isMasterAccount) {
 print("Yes, is Master account")
 }
 }
 */
func isMasterAccount(callback: (Bool) -> Void) {
    let ref = FIRDatabase.database().reference()
    let refMasterAccounts = ref.child("Master Accounts")
    var verified = false
    refMasterAccounts.observeSingleEventOfType(.Value, withBlock: { snapshot in
        
        if (snapshot.hasChild(getCurrentUserId()) && (FIRAuth.auth()?.currentUser?.emailVerified)!) {
            verified = true
        }
        callback(verified)
    })
}

/*Asynchronous func that returns bool based on whether current account is a Tech Account
 isTechAccount() { (isTechAccount) in
 if(isTechAccount) {
 print("Yes, is tech account")
 }
 }
 */
func isTechAccount(callback: (Bool) -> Void) {
    var isTechAccount = false
    let refTechAccounts = FIRDatabase.database().reference().child("Tech Accounts")
    refTechAccounts.observeSingleEventOfType(.Value, withBlock: { snapshot in
        if (snapshot.hasChild(getCurrentUserId())) {
            isTechAccount = true
        }
        callback(isTechAccount)
    })
}


func getCurrentUserId() -> String {
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        return userID
    }
    return ""
}

func getPrimaryEmail() -> String {
    if let primaryEmail = FIRAuth.auth()?.currentUser?.email {
        return primaryEmail
    }
    return ""    
}

//Request Master Account, uses company and userid for easy lookup
func requestMasterAccount(company: String) {
    let ref = FIRDatabase.database().reference()
    let requestsRef = ref.child("Requests")
    if let user = FIRAuth.auth()?.currentUser {
        let userInfo = ["Company": company,
                        "Email": user.email! as String]
        requestsRef.child(user.uid).setValue(userInfo)
    }
    
}

//Removes user from Requests and adds to Master Accounts
func verifyMasterAccount(account: String) {
    let ref = FIRDatabase.database().reference()
    let company = ref.child("Requests/\(account)").valueForKey("Company")
    ref.child("Requests/\(account)").removeValue()
    ref.child("Master Accounts/\(account)").setValue(company)
}

//Email verification
/*func verifyEmail()
 let currentUser = FIRAuth.auth()?.currentUser
 currentUser?.sendEmailVerificationWithCompletion({
 
 })
 
 }*/

//Save an event for the current user
func saveEvent(event: Event) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let eventDictionary = ["title": event.title,
                               "startTime": event.startTime.timeIntervalSince1970,
                               "endTime": event.endTime.timeIntervalSince1970,
                               "location": event.location,
                               "eventDescription": event.eventDescription]
        
        ref.child("users/\(userID)/events/\(event.UUID)").setValue(eventDictionary)
    }
}

//Save an event for another user, helper function for requestMasterAccount()
func saveEvent(event: Event, uID: String?) {
    let ref = FIRDatabase.database().reference()
    if let userID = uID {
        let eventDictionary = ["title": event.title,
                               "startTime": event.startTime.timeIntervalSince1970,
                               "endTime": event.endTime.timeIntervalSince1970,
                               "location": event.location,
                               "eventDescription": event.eventDescription]//,
                                //"contactName": event.contactName]
        
        ref.child("users/\(userID)/events/\(event.UUID)").setValue(eventDictionary)
    }
}

//Save an event for another user, helper function for requestMasterAccount()
func saveImagePost(school: String, event: EventWithImage, callback: (Bool) -> Void) { //shouldn't ;mage post have time and location just in case?
    // Ensure we are not uploading a massive picture
    if UIImagePNGRepresentation(event.image)?.length > MAX_FILE_SIZE {
        callback(false)
        return
    }
    let ref = FIRDatabase.database().reference()
    let schoolRef = ref.child("schools/\(school)")
    let userID = currentUser.userId
        let eventDictionary = ["title": event.title,
                               "location": event.location,
                                "hasImage": true]
        
        let storageRef = FIRStorage.storage().referenceForURL(storageBucket)
        let pictureRef = storageRef.child("schools/\(school)/pics/\(event.UUID)")
        
        schoolRef.child("events/\(event.UUID)").setValue(eventDictionary)
        
        if let pictureData = UIImagePNGRepresentation(event.image) {
            let uploadTask = pictureRef.putData(pictureData, metadata: nil) { metadata, error in
                if (error != nil) {
                    callback(false)
                } else {
                    //succeeded
                    callback(true)
                }
            }
        } else {
            callback(false)
        }
    
}

//Add event notification to a school
func pushEventToSchool(school: String, event: Event) {
    
    let ref = FIRDatabase.database().reference()
    let schoolRef = ref.child("schools/\(school)")
    
    if event.hasImage != nil {
        let imageEvent = event as! EventWithImage
        saveImagePost(school, event: imageEvent) { bool in}
        return
    }
    if let userID = FIRAuth.auth()?.currentUser?.uid {

    let eventDictionary = ["title": event.title,
                           "startTime": event.startTime.timeIntervalSince1970,
                           "endTime": event.endTime.timeIntervalSince1970,
                           "postedTime": event.postedTime.timeIntervalSince1970,
                           "company": event.company,
                           "uuid": event.UUID,
                           "location": event.location,
                           "eventDescription": event.eventDescription]//,
        //"contactName": event.contactName]
        schoolRef.child("events/\(event.UUID)").setValue(eventDictionary)
    }
}

func pushEventToFollowers(event: Event) {
    let ref = FIRDatabase.database().reference()
    let followersRef = ref.child("(users)/\(getCurrentUserId())/followers")
    followersRef.observeSingleEventOfType(.Value, withBlock: {
        snapshot in
        for user in snapshot.children.allObjects as! [FIRDataSnapshot] {
            saveEvent(event, uID: user.key)
        }
    })
}


/* Asyncronous function to get all the events for the current user
 
 Sample Usage:
 getUserEvents() { (events) in
 for event in events {
 print("\n\(event.title)")
 print("\n\(event.eventDescription)")
 }
 }
 */
func getUserEvents(callback: ([Event]) -> Void){
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        ref.child("users/\(userID)/events").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            var events = [Event]()
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let event = Event()
                event.UUID = child.key
                if let title = childSnapshot.value?["title"] as? String {
                    event.title = title
                }
                if let startTime = childSnapshot.value?["startTime"] as? NSTimeInterval {
                    event.startTime = NSDate(timeIntervalSince1970: startTime)
                }
                if let endTime = childSnapshot.value?["endTime"] as? NSTimeInterval {
                    event.endTime = NSDate(timeIntervalSince1970: endTime)
                  
                }
                if let location = childSnapshot.value?["location"] as? String {
                    event.location = location
                }
                if let eventDescription = childSnapshot.value?["eventDescription"] as? String {
                    event.eventDescription = eventDescription
                }
                
                events.append(event)
            }
            events.sortInPlace({$0.startTime.compare($1.startTime) == .OrderedAscending})
            callback(events);
        })
    }
}

//Gets all events posted to a school
func getSchoolEvents(school: String, callback: ([Event]) -> Void) {
    let ref = FIRDatabase.database().reference()
    let schoolRef = ref.child("schools/\(school)")
    if let userID = FIRAuth.auth()?.currentUser?.uid {
       schoolRef.child("events").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            var events = [Event]()
        for child in snapshot.children {
            let childSnapshot = snapshot.childSnapshotForPath(child.key)
            let event = Event()
            
            if let hasImage = childSnapshot.value?["hasImage"] as? Bool {
               event.hasImage = hasImage
                getImageForPost(school, eventUUID: child.key) {
                    image in
                    (event as! EventWithImage).image = image!
                }
            }
            
            if let title = childSnapshot.value?["title"] as? String {
                event.title = title
            }
            if let startTime = childSnapshot.value?["startTime"] as? NSTimeInterval {
                event.startTime = NSDate(timeIntervalSince1970: startTime)
            }
            if let endTime = childSnapshot.value?["endTime"] as? NSTimeInterval {
                event.endTime = NSDate(timeIntervalSince1970: endTime)
                
            }
            if let postedTime = childSnapshot.value?["postedTime"] as? NSTimeInterval {
                event.postedTime = NSDate(timeIntervalSince1970: postedTime)
                
            }
            if let location = childSnapshot.value?["location"] as? String {
                event.location = location
            }
            if let eventDescription = childSnapshot.value?["eventDescription"] as? String {
                event.eventDescription = eventDescription
            }
            if let company = childSnapshot.value?["company"] as? String {
                event.company = company
            }
            if let uuid = childSnapshot.value?["uuid"] as? String {
                event.UUID = uuid
            }
            
            events.append(event)
        }
        
        events.sortInPlace({$0.startTime.compare($1.startTime) == .OrderedAscending})
        callback(events);
        
       })
        
    }

}

//helper method that gets the image for a certain post
func getImageForPost(school: String, eventUUID: String, callback: (UIImage?) -> Void) {
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let storageRef = FIRStorage.storage().referenceForURL(storageBucket)
        let pictureRef = storageRef.child("schools/\(school)/pics/\(eventUUID)")
        pictureRef.dataWithMaxSize(Int64(MAX_FILE_SIZE)) { (data, error) -> Void in
            if (error != nil) {
                callback(nil)
                return
            }
            
            if let data = data {
                callback(UIImage(data: data))
            } else {
                callback(nil)
            }
        }
    }
}

func deleteEvent(event: Event) {
    let ref = FIRDatabase.database().reference()
    let userID = getCurrentUserId()
    ref.child("users/\(userID)/events/\(event.UUID)").removeValue()
}

func deleteReminder(reminder: Reminder) {
    let ref = FIRDatabase.database().reference()
    let userID = getCurrentUserId()
    ref.child("users/\(userID)/reminders/\(reminder.UUID)").removeValue()
}

//Save an reminder for another user, helper function for requestMasterAccount()
func saveReminder(reminder: Reminder) {
    let ref = FIRDatabase.database().reference()
    let userID = getCurrentUserId()
    let reminderDictionary = ["affiliation": reminder.affiliation,
                               "time": reminder.time.timeIntervalSince1970,
                               "contactName": reminder.contactName]
        
    ref.child("users/\(userID)/reminders/\(reminder.UUID)").setValue(reminderDictionary)
    
}

func getUserReminders(callback: ([Reminder]) -> Void){
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        ref.child("users/\(userID)/reminders").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            var reminders = [Reminder]()
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let reminder = Reminder()
                reminder.UUID = child.key
                if let affiliation = childSnapshot.value?["affiliation"] as? String {
                    reminder.affiliation = affiliation
                }
                if let time = childSnapshot.value?["time"] as? NSTimeInterval {
                    reminder.time = NSDate(timeIntervalSince1970: time)
                }
            
                if let contactName = childSnapshot.value?["contactName"] as? String {
                    reminder.contactName = contactName
                }
                
                reminders.append(reminder)
            }
            reminders.sortInPlace({$0.time.compare($1.time) == .OrderedAscending})
            callback(reminders);
        })
    }
}

// add a connection from hitting "add contact", i.e any contact that is inputed by the user and not from QR code or adding nearby
func addManuallyAddedConnection(user: User, callback: (NSError?) -> Void) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let profile = ["firstName": user.firstName,
                       "lastName": user.lastName,
                       "secondaryEmail": user.secondaryEmail,
                       "company": user.company,
                       "phoneNumber": user.phoneNumber]
        ref.child("users/\(userID)/manuallyAddedConnections/\(user.userId)").setValue(profile, withCompletionBlock: { (error, firebaseReference) in
            callback(error)
        })
    }
}

func getManuallyAddedConnection(callback: ([User]) -> Void){
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        ref.child("users/\(userID)/manuallyAddedConnections").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            var connections = [User]()
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let user = User()
                user.userId = child.key
                if let firstName = childSnapshot.value?["firstName"] as? String {
                    user.firstName = firstName
                }
                if let lastName = childSnapshot.value?["lastName"] as? String {
                    user.lastName = lastName
                }
                if let secondaryEmail = childSnapshot.value?["secondaryEmail"] as? String {
                    user.secondaryEmail = secondaryEmail
                }
                if let company = childSnapshot.value?["company"] as? String {
                    user.company = company
                }
                if let phoneNumber = childSnapshot.value?["phoneNumber"] as? String {
                    user.phoneNumber = phoneNumber
                }
                
                connections.append(user)
            }
            connections.sortInPlace({$0.firstName.compare($1.firstName) == .OrderedAscending})
            callback(connections);
        })
    }
}

//Adds a connection for the current user
func addConnection(user: User, callback: (NSError?) -> Void) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let connection = ["id": user.userId]
        ref.child("users/\(userID)/connections/\(user.userId)").setValue(connection, withCompletionBlock: { (error, firebaseReference) in
            callback(error)
        })
    }
}

//Add a connection to a group
func addConnectionToMesh(newUserId: User, meshGroup: String) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let connection = ["id": newUserId]
        ref.child("users/\(userID)/mesh/\(meshGroup)").childByAutoId().setValue(connection)
    }
}

//Add a connection with userId
func addConnection(newUserID: String) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let connection = ["id": newUserID]
        ref.child("users/\(userID)/connections/\(newUserID)").childByAutoId().setValue(connection)
    }
}

func deleteConnection(user: User) {
    let ref = FIRDatabase.database().reference()
    let userID = getCurrentUserId()
    ref.child("users/\(userID)/connections/\(user.userId)").removeValue()
}


/* Asyncronous function to get all the connections that a user has
 
 Sample Usage:
 getConnections() { (users) in
 for user in users {
 print("\n\(user.firstName)")
 }
 }
 */
func getConnections(callback: ([User]) -> Void) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        ref.child("users/\(userID)/connections").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            var users = [User]()
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                if let id = childSnapshot.value?["id"] as? String {
                    let user = User()
                    user.userId = id
                    users.append(user)
                }
            }
            callback(users);
        })
    }
}

//Get all Mesh Groups
func getMeshGroups(callback: ([String]) -> Void) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        ref.child("users/\(userID)/mesh").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            var meshGroups = [String]()
            for child in snapshot.children {
                let mesh = child.key as String
                meshGroups.append(mesh)
            }
            callback(meshGroups)
        })
    }
}

//Get all connections of a mesh group and returns an array of user ids
func getConnectionsFromGroup(meshGroup: String, callback: ([String]) -> Void) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        ref.child("users/\(userID)/mesh/\(meshGroup)").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            var meshGroupMembers = [String]()
            for child in snapshot.children {
                let memberId = snapshot.valueForKey(child.key) as! String
                meshGroupMembers.append(memberId)
            }
            callback(meshGroupMembers)
        })
    }
}
/*Asynchronous function to get all Master Accounts
 
 (Only accessible by Tech Accounts, enforced by database)
 Sample Usage:
 getMasterConnections() { (references) in
 for account in references
 print(account.key)
 
 }
 */
func getMasterAccountRequests(callback: ([String:String]) -> Void) {
    var references = [String: String]()
    let ref = FIRDatabase.database().reference()
    if let _ = FIRAuth.auth()?.currentUser?.uid {
        ref.child("Requests").observeSingleEventOfType(.Value, withBlock: { snapshot in
            for user in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let company = user.value!["Company"] as! String
                print(company)
                let email = user.value!["Email"] as! String
                print(email)
                let info = company + " +  Email: " + email
                references[info] = user.key
            }
            callback(references)
        })
    }
}

/* Gets user Information from a given userId
 Sample Usage:
 getUserInformation(getCurrentUserId) { (user) in
 if let user = user {
 //successfully got information
 print("\(user.firstName)")
 print("\(user.lastName)")
 } else {
 // failed to get user information
 }
 }
 */
func getUserInformation(userId: String, callback: (User?) -> Void) {
    let ref = FIRDatabase.database().reference()
    ref.child("users/\(userId)/profile").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
        if(snapshot.value == nil) {
            callback(nil)
            return
        }
        let user = User()
        user.userId = userId
        if let firstName = snapshot.value?["firstName"] as? String {
            user.firstName = firstName
        }
        if let lastName = snapshot.value?["lastName"] as? String {
            user.lastName = lastName
        }
        if let school = snapshot.value?["school"] as? String {
            user.school = school
        }
        if let secondaryEmail = snapshot.value?["secondaryEmail"] as? String {
            user.secondaryEmail = secondaryEmail
        }
        if let company = snapshot.value?["company"] as? String {
            user.company = company
        }
        if let position = snapshot.value?["position"] as? String {
            user.position = position
        }
        if let phoneNumber = snapshot.value?["phoneNumber"] as? String {
            user.phoneNumber = phoneNumber
        }
        callback(user);
    })
}


// Save a picture in Firebase Storage for a user. The callback returns
// whether we successfully saved the picture
func savePicture(userId: String, picture: UIImage, callback: (Bool) -> Void) {
    // Ensure we are not uploading a massive picture
    if UIImagePNGRepresentation(picture)?.length > MAX_FILE_SIZE {
        callback(false)
        return
    }
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let storageRefence = FIRStorage.storage().referenceForURL(storageBucket)
        let pictureRefence = storageRefence.child("users/\(userID)/picture")
        if let pictureData = UIImagePNGRepresentation(picture) {
            let uploadTask = pictureRefence.putData(pictureData, metadata: nil) { metadata, error in
                if (error != nil) {
                    callback(false)
                } else {
                    //succeeded
                    callback(true)
                }
            }
        } else {
            callback(false)
        }
        
    }
}

/* Downloads the picture for a user
 
 Sample Usage:
 getPicture(id) { (image) in
 if let image = image {
 // got the picture
 } else {
 // failed to get picture
 }
 }
 */
func getPicture(userId: String, callback: (UIImage?) -> Void) {
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let storageRefence = FIRStorage.storage().referenceForURL(storageBucket)
        let pictureRef = storageRefence.child("users/\(userID)/picture")
        pictureRef.dataWithMaxSize(Int64(MAX_FILE_SIZE)) { (data, error) -> Void in
            if (error != nil) {
                callback(nil)
                return
            }
            
            if let data = data {
                callback(UIImage(data: data))
            } else {
                callback(nil)
            }
        }
    }
}

// Save a resume in Firebase Storage for a user. The callback returns
// whether we successfully saved the picture
func saveResume(resume: NSData, callback: (Bool) -> Void) {
    // Ensure we are not uploading a massive file
    if resume.length > MAX_FILE_SIZE {
        callback(false)
        return
    }
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let storageRefence = FIRStorage.storage().referenceForURL(storageBucket)
        let resumeRefence = storageRefence.child("users/\(userID)/resume")
        let uploadTask = resumeRefence.putData(resume, metadata: nil) { metadata, error in
            if (error != nil) {
                callback(false)
            } else {
                //uploaded successfully
                callback(true)
            }
        }
    }
}

/* Downloads the resume for a user
 
 Sample Usage:
 getResume(id) { (resumeData) in
 if let resumeData = resumeData {
 // got resume
 } else {
 // failed to get resume
 }
 }
 */
func getResume(userId: String, callback: (NSData?) -> Void) {
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let storageRefence = FIRStorage.storage().referenceForURL(storageBucket)
        let resumeRef = storageRefence.child("users/\(userID)/resume")
        resumeRef.dataWithMaxSize(Int64(MAX_FILE_SIZE)) { (data, error) -> Void in
            if (error != nil) {
                callback(nil)
            }
            callback(data)
        }
    }
}



func changeAccountEmail(newEmail: String) {
    let user = FIRAuth.auth()?.currentUser
    user?.updateEmail(newEmail, completion: { (callback) in
    })
}

func changePassword(newPassword: String) {
    let user = FIRAuth.auth()?.currentUser
    user?.updatePassword(newPassword, completion: {
        callback in
    })
}

func addSecondaryEmail(secondEmail: String) {
    let ref = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser
    ref.child("users/\(userID)/profile/secondaryEmail").setValue(secondEmail)
}

func signOUt() {
    let auth = FIRAuth.auth()
    
    do {
        try auth?.signOut()
    } catch let error {
        print(error)
    }
    
}

//adds user to the list of followers on a master account
func followCompany(companyId: String) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let follower = ["id": getCurrentUserId()]
        let following = ["id": companyId]
        ref.child("users/\(companyId)/followers").childByAutoId().setValue(follower)
        ref.child("users/\(getCurrentUserId())/following").childByAutoId().setValue(following)
        
    }
}

