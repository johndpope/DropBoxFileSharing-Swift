//
//  AppDelegate.swift
//  fmdb
//
//  Created by macpc on 23/02/15.
//  Copyright (c) 2015 macpc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var testNavigationController: UINavigationController?
    var myViewController:viewcontroller?
    let databasePath = NSString()
    var dbFileName = "PizzaSystemDB.sqlite"



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        [self.copyFile(dbFileName)]
        let dropboxRoot:NSString = kDBRootAppFolder;  // either kDBRootAppFolder or kDBRootDropbox

        let dbsession = DBSession(appKey: "ymzgypyw389pcd2", appSecret: "t53och8drrs2lft", root: dropboxRoot as String)
        DBSession.setSharedSession(dbsession)
        
        
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let mainViewController = viewcontroller(nibName: "viewcontroller", bundle: nil)
        
        mainViewController.sqlitepath = dbFileName
        let navigationController = UINavigationController(rootViewController: mainViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
//        DBSession *dbSession = [[DBSession alloc]
//            initWithAppKey:@"INSERT_APP_KEY"
//        appSecret:@"INSERT_APP_SECRET"
//        root:INSERT_ACCESS_TYPE]; // either kDBRootAppFolder or kDBRootDropbox
//        [DBSession setSharedSession:dbSession];

        
        //let accountManager = DBAccountManager(appKey: "rodqmschsygdbdp", secret: "esvav7nfw2igrlq")
        //DBAccountManager.setSharedManager(accountManager)
        
        
        return true
    }
    /*
    func uploadfile(account:DBAccount) -> Bool
    {
        let filesystem = DBFilesystem(account: account)
        DBFilesystem.setSharedFilesystem(filesystem)
        
        // self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        // self.restClient.delegate = self;
        
        
        let path = DBPath()
        let info = try! filesystem.fileInfoForPath(path, error: nil)
        
        if (info == nil) {
            let fileis = DBFilesystem.sharedFilesystem().createFile(path, error: nil)
            fileis.writeContentsOfFile(dbFileName, shouldSteal: true, error: nil)
        }
        else
        {
            print("fiel exist")
        }
        return true
    }
 */

    func copyFile(fileName: NSString) {
        let fileManager = NSFileManager.defaultManager()
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        let destinationSqliteURL = documentsPath.URLByAppendingPathComponent(dbFileName)
        let sourceSqliteURL = NSBundle.mainBundle().URLForResource("PizzaSystemDB", withExtension: "sqlite")
        print("path==>>\(destinationSqliteURL)")
        dbFileName = documentsPath.path!

        
        if !fileManager.fileExistsAtPath(destinationSqliteURL.path!) {
            // var error:NSError? = nil
            do {
                try fileManager.copyItemAtURL(sourceSqliteURL!, toURL: destinationSqliteURL)
                print("Copied")
                print(destinationSqliteURL.path)
            } catch let error as NSError {
                print("Unable to create database \(error.debugDescription)")
            }
        }
        else
        {
        }
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        NSUserDefaults.standardUserDefaults().setObject(url.description, forKey: "url")
        
        if DBSession.sharedSession().handleOpenURL(url)
        {
            return true
        }
        return true
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

