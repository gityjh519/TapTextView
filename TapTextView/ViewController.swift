//
//  ViewController.swift
//  TapTextView
//
//  Created by yaojinhai on 2021/4/9.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tipLabel = UILabel(frame: .init(x: 0, y: 40, width: view.frame.width, height: 60))
        tipLabel.textAlignment = .center
        view.addSubview(tipLabel)
        
        
        
        let tapView = TapTextKitView(frame: .init(x: 0, y: tipLabel.frame.maxY + 10, width: view.frame.width, height: 400), textContainer: nil)
        view.addSubview(tapView)
        tapView.font = UIFont.systemFont(ofSize: 18)
        let firstText = TapLinkText()
        firstText.linkText = "人应行善"
        firstText.isSupportBreakLine = false
        
        firstText.defultAttibute = [.font: UIFont.systemFont(ofSize: 15),.foregroundColor: UIColor.yellow]


        firstText.tapAction = {
            (range: NSRange) in
            tipLabel.text = "点击了: " + firstText.linkText! + "索引：\(range.location)"
        }
        let secondText = TapLinkText()
        secondText.linkText = "《增广贤文》"
        secondText.isSupportBreakLine = false
        secondText.defultAttibute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),NSAttributedString.Key.foregroundColor: UIColor.red]
        secondText.didTapAttibute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),NSAttributedString.Key.foregroundColor: UIColor.green]

        secondText.tapAction = {
            (range: NSRange) in
            tipLabel.text = "点击了: " + secondText.linkText!  + "索引：\(range.location)"
        }
        tapView.addLinkTextItems(items: [firstText,secondText])
        
        tapView.text = "《增广贤文》简介：《增广贤文》的内容大致有这样几个方面：一是谈人及人际关系，二是谈命运，三是谈如何处世，四是表达对读书的看法。在《增广贤文》描述的世界里，人是虚伪的，人们为了一己之私变化无常，嫌贫爱富，趋炎附势，从而使世界布满了陷阱和危机。文中有很多强调命运和报应的内容，认为人的一切都是命运安排的，人应行善，才会有好的际遇。《增广贤文》有大量篇幅叙述如何待人接物，这部分内容是全文的核心。文中对忍让多有描述，认为忍让是消除烦恼祸患的方法。在主张自我保护、谨慎忍让的同时，也强调人的主观能动性，认为这是做事的原则。文中也不乏劝人向善“害人之心不可有，防人之心不可无。”"
        tapView.reloadTextAttibuteLink()
    }


}

