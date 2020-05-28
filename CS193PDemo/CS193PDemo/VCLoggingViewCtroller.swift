//
//  ViewController.swift
//  CS193PDemo
//
//  Created by tidot on 2020/3/3.
//  Copyright © 2020 tidot. All rights reserved.
//

import UIKit
import Foundation

class VCLoggingViewCtroller: UIViewController {
    
    private struct LogGlobals{
        var prefix = ""
        var instanceCounts = [String: Int]()
        var lastLogTime = Date()
        var indentationInterval: TimeInterval = 1
        var indentationString = "__"
    }
    
    private static var logGlobals = LogGlobals()
    
    private static func logPrefix(for loggingName: String) -> String{
        if logGlobals.lastLogTime.timeIntervalSinceNow < -logGlobals.indentationInterval{
            logGlobals.prefix += logGlobals.indentationString
            print("")
        }
        
        logGlobals.lastLogTime = Date()
        return logGlobals.prefix + loggingName
    }
    
    private static func bumpInstanceCount(for loggingName: String) -> Int{
        logGlobals.instanceCounts[loggingName] = (logGlobals.instanceCounts[loggingName] ?? 0) + 1
        return logGlobals.instanceCounts[loggingName]!
    }
    
    private var instanceCount: Int!
    
    var vclLoggingName: String{
        return String(describing: type(of: self))
    }
    
    private func logVCL(_ msg: String){
        if instanceCount == nil{
            instanceCount = VCLoggingViewCtroller.bumpInstanceCount(for: vclLoggingName)
        }
        print("\(VCLoggingViewCtroller.logPrefix(for: vclLoggingName))(\(instanceCount!)) \(msg)")
    }
    
    //MARK: - Life Cycle
    
    ///从storyboard加载
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        logVCL("init?(coder:) - create via InterfaceBuilder ")
    }
    
    ///通过Xib或其它非storyboard方式加载
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        logVCL("init(nibName:bundle:) - create in code")
    }
    
    override func loadView() {
        
    }
    
    ///加载完成后
    override func awakeFromNib() {
        super.awakeFromNib()
        
        logVCL("awakeFromNib()")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logVCL("viewDidLoad()")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logVCL("viewWillAppear(animate = \(animated)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logVCL("viewDidAppear(animate = \(animated)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        logVCL("viewWillDisappear(animate = \(animated)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        logVCL("viewDidDisappear(animate = \(animated)")
    }
    
    deinit {
        logVCL("left the heap")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        logVCL("didReceiveMemoryWarning")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        logVCL("viewWillLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logVCL("viewDidLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        logVCL("viewWillTransition(to: \(size), with: coordinator")
        coordinator.animate(alongsideTransition: { (context) in
            self.logVCL("begin animate(alongsideTransition:completion:)")
        }) { (context) in
            self.logVCL("end animate(alongsideTransition:completion:)")
        }
        
    }
}
