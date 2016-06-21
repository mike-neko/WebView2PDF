//
//  ViewController.swift
//  WebView2PDF
//
//  Created by M.Ike on 2016/06/21.
//  Copyright © 2016年 M.Ike. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet private weak var webContainerView: UIView!
    private weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let web = WKWebView(frame: webContainerView.bounds)
        webContainerView.addSubview(web)
        webView = web
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://google.com")!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        webView.frame = webContainerView.bounds
    }
    
    @IBAction func tapCapture(sender: UIBarButtonItem) {
        // 保存先のパス
        guard let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first else { return }
        guard let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("capture.pdf").path else { return }
        
        // PDFファイル生成開始
        guard UIGraphicsBeginPDFContextToFile(path, CGRect.zero, nil) else { return }
        
        // 全体がPDFになるようにスクロールビューの位置とサイズを変更
        let old = webView.scrollView.contentOffset
        webView.scrollView.contentOffset = CGPoint.zero
        let frame = CGRect(origin: CGPoint.zero, size: webView.scrollView.contentSize)
        webView.scrollView.frame = frame
        
        // 書き出し
        UIGraphicsBeginPDFPageWithInfo(frame, nil)
        webView.scrollView.drawViewHierarchyInRect(frame, afterScreenUpdates: true)
        
        UIGraphicsEndPDFContext()
        
        // 変更したスクロールビューを元に戻す
        webView.scrollView.frame = webContainerView.bounds
        webView.scrollView.contentOffset = old
    }
}
