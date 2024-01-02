
import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    var post : [Post] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        initializeTableView()
        registerXIBWithTableView()
    }
    func initializeTableView()
    {
        postTableView.dataSource = self
        postTableView.delegate = self
    }
    func registerXIBWithTableView()
    {
        let uinib = UINib(nibName: "PostTableViewCell", bundle: nil)
        postTableView.register(uinib, forCellReuseIdentifier: "PostTableViewCell")
    }
    func fetchData()
    {
        let postUrl = URL(string: "https://jsonplaceholder.typicode.com/photos")
        var postRequest = URLRequest(url: postUrl!)
        postRequest.httpMethod = "Get"
        let postUrlSession = URLSession(configuration: .default)
        let postDataTask = postUrlSession.dataTask(with: postRequest) { postData, postResponse, postError in
        let postResponse = try! JSONSerialization.jsonObject(with: postData!) as! [[String :Any]]
         //   let postResponse1 = postResponse["post"] as! [[String : Any]]
            
            for eachResponse in postResponse{
            
                let postAlbumId = eachResponse["albumId"]as! Int
                let postId = eachResponse ["id"]as! Int
                let posttitle = eachResponse ["title"] as! String
                
                let postUrl = eachResponse ["url"] as! String
                
                let postObject = Post(albumId: postAlbumId, id: postId, title: posttitle, url: postUrl)
                
                self.post.append(postObject)
            }
            DispatchQueue.main.async {
                self.postTableView.reloadData()
            }
        }
        postDataTask.resume()
    }
}
extension ViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postTableViewCell = self.postTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        postTableViewCell.albumIdLabel.text = String(post[indexPath.row].albumId)
        postTableViewCell.idLabel.text = String(post[indexPath.row].id)
        postTableViewCell.titleLabel.text = post[indexPath.row].title
        postTableViewCell.imageViewLabel.kf.setImage(with:URL(string: post[indexPath.row].url))
        
        return postTableViewCell
    }
}
extension ViewController : UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150.5
    }
}


