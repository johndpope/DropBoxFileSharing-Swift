//
//  viewcontroller.swift
//  fmdb
//
//  Created by macpc on 23/02/15.
//  Copyright (c) 2015 macpc. All rights reserved.
//
//
import UIKit

class viewcontroller: UIViewController, DBRestClientDelegate {

    var fileName = "PizzaSystemDB.sqlite"
    
    var dictionary=NSMutableDictionary()
    
    var fmdb = DBManagerClass()
    
    var sqlitepath = NSString()
    var restClient = DBRestClient()
    
    @IBOutlet var txtname: UITextField!
    @IBOutlet var txtemailid: UITextField!
    
    override func viewDidLoad() {
        
        ///http://www.technetexperts.com/mobile/interact-with-whatsapp-from-ios-application/
        //As per this whatsapp forum link, there is no way you can send message to specific user, this is not available within whatsapp URL scheme.
        //You just set predefined message and then with URL scheme you are able to open whatsapp recent controller.
        ///http://stackoverflow.com/questions/40535309/open-whatsapp-on-a-particular-number-in-swift
        let whatsappUTL = NSURL(string: "whatsapp://send?text=Hello%2C%20World!")
        if UIApplication.sharedApplication().canOpenURL(whatsappUTL!)
        {
            UIApplication.sharedApplication().openURL(whatsappUTL!)
        }
        self.restClient = DBRestClient(session: DBSession.sharedSession())
        self.restClient.delegate = self;
        self.restClient.loadMetadata("/")
        
      //  self.restClient.deletePath("/backup.zip")
        super.viewDidLoad()
    }
    @IBAction func btnCreateZipAction(sender: UIButton) {
        
        var tempDirectory = NSTemporaryDirectory()
        print("tempdirectory \(tempDirectory)")
        tempDirectory += "/backup.zip"
        let success = SSZipArchive.createZipFileAtPath(tempDirectory, withContentsOfDirectory: NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0])
        if success {
            print("success")
        }
        else{
            print("failed")
        }
    }
    @IBAction func btnUploadToAction(sender: UIButton) {
        
        
        let localDir = NSTemporaryDirectory()
        let filename = "backup.zip"
        let localPath = localDir.stringByAppendingString("/" + filename)
        self.restClient.uploadFile(filename, toPath: "/", withParentRev: nil, fromPath: localPath)
        
        
//        let filename = "backup.zip"
//        let localDir : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
//        let localPath = localDir.stringByAppendingString("/" + filename)
//        self.restClient.uploadFile(filename, toPath: "/", withParentRev: nil, fromPath: localPath)
    }
    @IBAction func btnDownloadAction(sender: UIButton) {
        
//        let filename = "/backup.zip"
//        let localDir : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
//        let localPath = localDir.stringByAppendingString("/" + filename)
//        self.restClient.loadFile(filename, intoPath: localPath)
        
        
                let filename = "/backup.zip"
                let localDir = NSTemporaryDirectory()
                let localPath = localDir.stringByAppendingString("/" + filename)
                self.restClient.loadFile(filename, intoPath: localPath)
    }
    @IBAction func btnExtractZipAction(sender: UIButton) {
        
//        let tempdirecory = NSTemporaryDirectory()
//        let localDir : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
//        SSZipArchive.unzipFileAtPath(localDir + "/backup.zip", toDestination: tempdirecory)
        
        
                let tempdirecory = NSTemporaryDirectory()
                let localDir : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
                SSZipArchive.unzipFileAtPath(tempdirecory + "/backup.zip", toDestination: localDir)
    }
    
    @IBAction func btnlogin(sender: UIButton) {
        
            DBSession.sharedSession().linkFromController(self)
    }
    
    
    @IBAction func tmpDirectoryAction(sender: UIButton) {
        
        var documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first!
        documentsUrl = documentsUrl.URLByAppendingPathComponent("DropBoxResporeFolder/")
        
//        var documentsUrl = NSTemporaryDirectory() + "DropBoxResporeFolder/"
        
        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL( documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            for i in 0...directoryContents.count - 1
            {
                let sourcePath = directoryContents[i]
                let newsde = sourcePath.path?.stringByReplacingOccurrencesOfString("DropBoxResporeFolder/", withString: "")
                let paths = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
                
                print("sourcePath.description \(newsde)");
                
                let fileManager = NSFileManager.defaultManager()
                
                var isDir : ObjCBool = false
                if fileManager.fileExistsAtPath(newsde!, isDirectory:&isDir) {
                    if isDir {
                        print("file exists and is a directory")
                    } else {
                        print("file exists and is not a directory")
                        //  try! fileManager.replaceItemAtURL(sourcePath, withItemAtURL: paths, backupItemName: nil, options: NSFileManagerItemReplacementOptions.UsingNewMetadataOnly, resultingItemURL: nil)
                        //try! fileManager.copyItemAtPath(sourcePath.path!, toPath: newsde!)
                    }
                } else {
                    // file does not exist
                    print("file is not exists")
                    try! fileManager.copyItemAtPath(sourcePath.path!, toPath: newsde!)
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        
    }
    
    @IBAction func btnCopyAction(sender: UIButton) {
        
        var documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        documentsUrl = documentsUrl.URLByAppendingPathComponent("DropBoxResporeFolder/")
        
        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL( documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            for i in 0...directoryContents.count - 1
            {
                let sourcePath = directoryContents[i]
                let newsde = sourcePath.path?.stringByReplacingOccurrencesOfString("DropBoxResporeFolder/", withString: "")
                let paths = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])

                print("sourcePath.description \(newsde)");
                
                let fileManager = NSFileManager.defaultManager()

                
                var isDir : ObjCBool = false
                if fileManager.fileExistsAtPath(newsde!, isDirectory:&isDir) {
                    if isDir {
                        print("file exists and is a directory")
                    } else {
                        print("file exists and is not a directory")
                      //  try! fileManager.replaceItemAtURL(sourcePath, withItemAtURL: paths, backupItemName: nil, options: NSFileManagerItemReplacementOptions.UsingNewMetadataOnly, resultingItemURL: nil)
                        //try! fileManager.copyItemAtPath(sourcePath.path!, toPath: newsde!)
                    }
                } else {
                    // file does not exist
                    print("file is not exists")
                    try! fileManager.copyItemAtPath(sourcePath.path!, toPath: newsde!)
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    func restClient(client: DBRestClient, loadedMetadata metadata: DBMetadata) {
        if metadata.isDirectory {
            print("Folder '\(metadata.path!)' contains:")
            for file in metadata.contents {
                
                print("\(file)")
                print("\(file)")

                //[AnyObject] does not conform to protocol 'sequenceType'
            }
        }
    }
    func restClient(client: DBRestClient!, loadMetadataFailedWithError error: NSError!) {
        print("load meta data fialed")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func restClient(client: DBRestClient!, uploadedFile destPath: String!, from srcPath: String!, metadata: DBMetadata!) {
        print("upload file sucess fully")
    }
    /*
     - (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
     NSLog(@"File upload failed with error: %@", error);
     }
     */
    func restClient(client: DBRestClient!, uploadFileFailedWithError error: NSError!) {
        print("faile to upload")
    }
    @IBAction func btnsubmit(sender: UIButton)
    {
        dictionary = ["first_name": txtname.text!, "email": txtemailid.text!, "facebook_id": txtemailid.text!]
        fmdb.InsertDynamictData("user", dictionary)
        txtname.text=""
        txtemailid.text=""
        txtname .becomeFirstResponder()
       
        if !DBSession.sharedSession().isLinked()
        {
            DBSession.sharedSession().linkFromController(self)
        }
        else
        {
            
            //Download file from the dropbox
            /*
            let filename = "/1.png"
            let localDir : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
            let localPath = localDir.stringByAppendingString("/" + filename)
            self.restClient.loadFile(filename, intoPath: localPath)
             */
        }
        let filename = "1.png"
        let localDir : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let localPath = localDir.stringByAppendingString("/" + filename)
        self.restClient.uploadFile(filename, toPath: "/", withParentRev: nil, fromPath: localPath)
        
    }
    func restClient(client: DBRestClient!, loadedFile destPath: String!, contentType: String!, metadata: DBMetadata!) {
        print("file loaded into path")
    }
    func restClient(client: DBRestClient!, loadFileFailedWithError error: NSError!) {
        print("file load failed into path")
    }
    @IBAction func btndelete(sender: UIButton)
    {
        let filename = "/1.png"
        let paths = (NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("/DropBoxResporeFolder/")
        
       // let paths = NSTemporaryDirectory() + "DropBoxResporeFolder"

        let fileManager = NSFileManager.defaultManager()
         if !fileManager.fileExistsAtPath(paths as String)
         {
         try!fileManager.createDirectoryAtPath(paths as String, withIntermediateDirectories: true, attributes: nil)
         }else{
         }
        let localDir : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        
        print("local dire \(localDir)")
        
        print("paths dire \(paths)")

        
        
      //  let localPath = localDir.stringByAppendingString("/DropBoxResporeFolder/" + filename)
//        self.restClient.loadFile(filename, intoPath: localDir)
        SSZipArchive.unzipFileAtPath(localDir + "/backup.zip", toDestination: paths)
        
        
        
    }
    /*
    func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName)
        println("copyFile fileName=\(fileName) to path=\(dbPath)")
        var fileManager = NSFileManager.defaultManager()
        var fromPath: String? = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent(fileName)
        if !fileManager.fileExistsAtPath(dbPath) {
            println("dB not found in document directory filemanager will copy this file from this path=\(fromPath) :::TO::: path=\(dbPath)")
            fileManager.copyItemAtPath(fromPath!, toPath: dbPath, error: nil)
        } else {
            println("DID-NOT copy dB file, file allready exists at path:\(dbPath)")
        }
    }
    func getPath(fileName: String) -> String {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent("PizzaSystemDB.sqlite")
    }
*/
}