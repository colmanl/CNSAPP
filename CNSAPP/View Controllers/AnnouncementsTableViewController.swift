//
//  AnnouncementsTableViewController.swift
//  CNSAPP
//
//  Created by Robert Colman Loch on 12/2/21.
//

import UIKit

class AnnouncementsTableViewController: UITableViewController {
    static let refreshNewsFeedNotification = Notification.Name(rawValue: "RefreshNewsFeedNotification")
    let newsStore = NewsStore.shared

    override var prefersStatusBarHidden: Bool {
      return true
    }

    override func viewDidLoad() {
      super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

      tableView.rowHeight = UITableView.automaticDimension
      tableView.estimatedRowHeight = 75

      if let patternImage = UIImage(named: "pattern-grey") {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(patternImage: patternImage)
        tableView.backgroundView = backgroundView
      } 

      NotificationCenter.default.addObserver(
        self,
        selector: #selector(AnnouncementsTableViewController.receivedRefreshNewsFeedNotification(_:)),
        name: AnnouncementsTableViewController.refreshNewsFeedNotification,
        object: nil)
    }

    @objc func receivedRefreshNewsFeedNotification(_ notification: Notification) {
      DispatchQueue.main.async {
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
      }
    }
  }

  // MARK: - UITableViewDataSource, UITableViewDelegate
  extension AnnouncementsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return newsStore.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell", for: indexPath)
      if let newsCell = cell as?  NewsItemCell {
        newsCell.updateWithNewsItem(newsStore.items[indexPath.row])
      }
      return cell
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
      let item = newsStore.items[indexPath.row]
      if let url = URL(string: item.link), url.scheme == "https" {
        return true
      }
      return false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let item = newsStore.items[indexPath.row]

      guard let url = URL(string: item.link) else {
        return
      }
      let safari = WenderSafariViewController(url: url)
      present(safari, animated: true, completion: nil)
    }
  }








/*{
    var initialNotification : [String : AnyObject]?

    override func viewDidLoad() {
        super.viewDidLoad()
       // requestNotificationAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let aps = initialNotification {
            processNotification(aps: aps)
        }
    }
    
    func processNotification(aps: [String : AnyObject]){
        let alert = UIAlertController(title: aps["category"] as? String, message: aps["alert"] as? String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    }

*/
