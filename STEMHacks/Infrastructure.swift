//
//  Infrastructure.swift
//  STEMHacks
//
//  Created by Ethan Miller on 12/24/20.
//

import Foundation
import Firebase


//DO NOT MEDDLE WITH THIS FILE
//including you Pranav


//class to hold functions to connect to, send and recieve data from the data base
class Server {
    //class to hold functions to send and receive announcements
    class Announcements {
        //class to hold funtions to receive data
        class Receive {
            //constant to represent connection to announcements collection
            let announceRef = Firestore.firestore().collection("Announcements")
            
            //function to return the main announcement
            func main(complete: @escaping (String?, Errors.FirebaseErrors?) -> Void) {
                //make connection to the main announcements document
                announceRef.document("Regular").getDocument { (document, error) in
                    //run error check
                    if error != nil {
                        //handle error
                        print(error! as NSError)
                        complete(nil, .downloadError)
                    } else {
                        //download the data and assign to a constant
                        let announcement = document?.data()?["mainAnnouncement"] as! String
                        
                        //run completion function
                        complete(announcement, nil)
                    }
                }
            }
            
            //function to return the array of current announcements
            func regulars(complete: @escaping ([String]?, Errors.FirebaseErrors?) -> Void) {
                //make connection to the regular announcements document
                announceRef.document("Regular").getDocument { (document, error) in
                    //run error check
                    if error != nil {
                        //handle error
                        print(error! as NSError)
                        complete(nil, .downloadError)
                    } else {
                        //download the data and assign to a constant
                        let announcements = document?.data()?["regularAnnouncements"] as! [String]
                        
                        //run completion function
                        complete(announcements, nil)
                    }
                }
            }
            
            //function to return the array of all announcements, including old ones
            func all(complete: @escaping ([String]?, Errors.FirebaseErrors?) -> Void) {
                //make connection to the all anouncements document
                announceRef.document("Regular").getDocument { (document, error) in
                    //run error check
                    if error != nil {
                        //handle error
                        print(error! as NSError)
                        complete(nil, .downloadError)
                    } else {
                        //download data and assign to a constant
                        let announcements = document?.data()?["allAnouncements"] as! [String]
                        
                        //run completion function
                        complete(announcements, nil)
                    }
                }
            }
        }
        
        //class to hold functions to send data
        class Send {
            //constant to represent connection to announcements collection
            let announceRef = Firestore.firestore().collection("Announcements")
            
            //function to upload data to the main announcements
            func main(data: String, complete: @escaping (Errors.FirebaseErrors?) -> Void) {
                //upload data to the main announcements document
                announceRef.document("Regular").updateData(["mainAnnouncement" : data]) { (error) in
                    //run error check
                    if error != nil {
                        print(error! as NSError)
                        complete(.uploadError)
                    } else {
                        complete(nil)
                    }
                }
            }
            
            //function to update data for the regular announcemnts
            func regular(newValue: String, complete: @escaping (Errors.FirebaseErrors?) -> Void) {
                //establish connection to the regular announcements document
                announceRef.document("Regular").getDocument {(document, downloadError) in
                    //run error check
                    if downloadError != nil {
                        //handle error
                        print(downloadError! as NSError)
                        complete(.downloadError)
                    } else {
                        //download current list of regular announcements
                        var announcements = document?.data()?["regularAnnouncements"] as! [String]
                        
                        //add the new announcement to the array
                        announcements.append(newValue)
                        
                        //upload the new array
                        self.announceRef.document("Regular").updateData(["regularAnnouncements": announcements]) { (uploadError) in
                            //run error check
                            if uploadError != nil {
                                complete(.uploadError)
                            } else {
                                //run function to upload the new announcement to the all announcements document
                                self.all(newValue: newValue) { (allError) in
                                    //run error check
                                    if allError != nil {
                                        print(allError!)
                                        complete(allError)
                                    } else {
                                        complete(nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            //function to update data for the all announcments data
            func all(newValue: String, complete: @escaping (Errors.FirebaseErrors?) -> Void) {
                //establish connectio to the all announcements document
                announceRef.document("Regular").getDocument { (document, downloadError) in
                    //run error check
                    if downloadError != nil {
                        //handle error
                        print(downloadError! as NSError)
                        complete(.downloadError)
                    } else {
                        //download list of all announcements
                        var announcements = document?.data()?["allAnnouncements"] as! [String]
                        
                        //add new value to the array
                        announcements.append(newValue)
                        
                        //upload the new value
                        self.announceRef.document("Regular").updateData(["allAnnouncements": announcements])
                    }
                }
            }
        }
        
        //class to delete data
        class delete {
            //constant to represent connection to announcements collection
            let announceRef = Firestore.firestore().collection("Announcements")
            
            //function to delete the data for the main announcemnts
            func main(complete: @escaping (Errors.FirebaseErrors?) -> Void) {
                announceRef.document("Regular").updateData(["mainAnnouncement": ""]) { (error) in
                    //run error check
                    if error != nil {
                        print(error! as NSError)
                        complete(.unknownError)
                    } else {
                        complete(nil)
                    }
                }
            }
            
            //function to delete specific data for the regular announcments
            func regular(index: Int?, text: String?, complete: @escaping (Errors.FirebaseErrors?) -> Void) {
                //run function to download the list of regular announcements
                Receive().regulars { (announcements, error) in
                    //run error check
                    if error != nil {
                        print(error!)
                        complete(error)
                    } else {
                        //create variable to represent the edited announcements array
                        var editedAnnouncements = announcements
                        
                        //run if statement to determine the method that the item will be removed
                        if index != nil {
                            editedAnnouncements!.remove(at: index!)
                        } else {
                            editedAnnouncements!.remove(at: announcements!.firstIndex(of: text!)!)
                        }
                        
                        //run function to upload the new announcements
                        self.announceRef.document("Regular").updateData(["regularAnnouncements": editedAnnouncements!]) { (error) in
                            //run error check
                            if error != nil {
                                print(error! as NSError)
                                complete(.unknownError)
                            } else {
                                complete(nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //class to hold functions to send and receive dates
    class Dates {
        //class to hold functions to receive data
        class Receive {
            
        }
        
        //class to hold functions to send data
        class Send {
            
        }
        
        //class to hold functions to delete data
        class Delete {
            
        }
    }
}


class Errors {
    enum FirebaseErrors {
        case downloadError
        case uploadError
        case unknownError
    }
    
    //function to take error and present a message
    func presentMessage(sender: UIViewController, error: FirebaseErrors) {
        //create constant representing the title text and details
        var title: String!
        var details: String!
        
        //switch statment to determine the titles
        switch error {
        case .downloadError:
            title = "Download Error"
            details = "There was an error downloading information. Please check your network connection."
        case .uploadError:
            title = "Upload Error"
            details = "There was an error uploading information. Please check your network connection."
        case .unknownError:
            title = "Unknown Error"
            details = "Please check your network connection"
        }
        
        //create constant representing the alert
        let alert = UIAlertController(title: title, message: details, preferredStyle: .alert)
        
        //add dismiss action
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        
        //present the alert
        sender.present(alert, animated: true, completion: nil)
    }
}
