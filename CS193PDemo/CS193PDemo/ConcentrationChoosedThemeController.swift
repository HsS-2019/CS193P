//
//  ConcentrationChoosedThemeController.swift
//  CS193PDemo
//
//  Created by tidot on 2020/2/18.
//  Copyright © 2020 tidot. All rights reserved.
//

import UIKit

class ConcentrationChoosedThemeController: VCLoggingViewCtroller {

    override var vclLoggingName: String{
        return "ThemeChooser"
    }
    // MARK: - Navigation

        let themes = [
        "Sports": "⚽️🏀🏈⚾️🥎🏐🏉🥏🎱🏓🏸🏒",
        "Animals": "🐶🐱🐭🐹🐰🦊🐻🐼🐨",
        "Faces": "😀😃😄😁😆😅😂🤣☺️😊😇",
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    @IBAction func ChooseTheme(_ sender: Any) {
//        if let vc = splitViewDetailConcentrationViewController{
//            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
//                vc.theme = theme
//            }
//        }else if let vc = lastSegueToConcentrationViewController{
//            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
//                vc.theme = theme
//            }
//            navigationController?.pushViewController(vc, animated: true)
//        }else{
            performSegue(withIdentifier: "ChooseTheme", sender: sender)
//        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController?{
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSegueToConcentrationViewController: ConcentrationViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseTheme"{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                if let vc = segue.destination as? ConcentrationViewController{
                    vc.theme = theme
                    lastSegueToConcentrationViewController = vc
                }
            }
        }
    }
}

extension ConcentrationChoosedThemeController: UISplitViewControllerDelegate{
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let vc = secondaryViewController as? ConcentrationViewController, vc.theme == nil{
            return true
        }
        return false
    }
}
