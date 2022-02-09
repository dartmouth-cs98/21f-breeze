import UIKit

//Island Class File
//class Island1 {
//    var backgroundColor = UIColor(red: 100/255, green: 173/255, blue: 218/255, alpha: 1);
//    var wallColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1);
//    var beach = "beach2";
//    var obstacleArray = ["berg"];
//    var boat = "boat2";
//    var dock = "dock2";
//}
//
//class Island2 {
//    var backgroundColor = UIColor(red: 240/255, green: 10/255, blue: 218/255, alpha: 1);
//    var wallColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1);
//    var beach = "beach";
//    var obstacleArray = ["city island"];
//    var boat = "boat";
//    var dock = "dock2";
//}
//
//

class Island {
    /*var count:Int = 0*/
    var backgroundColor: UIColor
    var wallColor: UIColor
    var boat: String
    var dock: String
    var beach: String
    init(backColor: UIColor, obstacleColor: UIColor, boatJPG: String, dockJPG: String, beachJPG: String) {
        self.backgroundColor = backColor
        self.wallColor = obstacleColor
        self.boat = boatJPG
        self.dock = dockJPG
        self.beach = beachJPG
    }
}

struct Islands {
    static let island1 = Island(
        backColor: UIColor(red: 100/255, green: 173/255, blue: 218/255, alpha: 1),
        obstacleColor: UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1),
        boatJPG: "boat2",
        dockJPG: "dock2",
        beachJPG: "beach2"
    )
    static let island2 = Island(
        backColor: UIColor(red: 240/255, green: 10/255, blue: 218/255, alpha: 1),
        obstacleColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        boatJPG: "boat",
        dockJPG: "dock",
        beachJPG: "beach"
    )
    static let island3 = Island(
        backColor: UIColor(red: 240/255, green: 10/255, blue: 218/255, alpha: 1),
        obstacleColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        boatJPG: "boat",
        dockJPG: "dock",
        beachJPG: "beach"
    )
    static let island4 = Island(
        backColor: UIColor(red: 240/255, green: 10/255, blue: 218/255, alpha: 1),
        obstacleColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        boatJPG: "boat",
        dockJPG: "dock",
        beachJPG: "beach"
    )
    static let island5 = Island(
        backColor: UIColor(red: 240/255, green: 10/255, blue: 218/255, alpha: 1),
        obstacleColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        boatJPG: "boat",
        dockJPG: "dock",
        beachJPG: "beach"
    )
}


