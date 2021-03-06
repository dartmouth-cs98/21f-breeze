import UIKit

class Island {
    /*var count:Int = 0*/
    var backgroundColor: UIColor
    var wallColor: UIColor
    var boat: String
    var dock: String
    var beach: String
    var wallTexture: String
    var wallTextureVert: String
    var obstacles: [String]
    var particleColor: UIColor
    init(backColor: UIColor, obstacleColor: UIColor, boatJPG: String, dockJPG: String, beachJPG: String, obstacleJPGs: [String], wallTextureString: String, wallTextureVertString: String, partColor: UIColor) {
        self.backgroundColor = backColor
        self.wallColor = obstacleColor
        self.boat = boatJPG
        self.dock = dockJPG
        self.beach = beachJPG
        self.obstacles = obstacleJPGs
        self.wallTexture = wallTextureString
        self.wallTextureVert = wallTextureVertString
        self.particleColor = partColor
    }
}

struct Islands {
    static let island1 = Island(
        backColor: UIColor(red: 82/255, green: 206/255, blue: 223/255, alpha: 1),
        obstacleColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        boatJPG: "boat",
        dockJPG: "dock",
        //beachJPG: "sand beach",
        beachJPG: "sandbeach_scaled",
        obstacleJPGs: ["seaweed", "starfish"],
        wallTextureString: "tropical wall",
        wallTextureVertString: "tropical wall vert",
        partColor: UIColor(red: 235/255, green: 246/255, blue: 254/255, alpha: 1)
    )
    static let island2 = Island(
        backColor: UIColor(red: 110/255, green: 162/255, blue: 194/255, alpha: 1),
        obstacleColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        boatJPG: "boat",
        dockJPG: "dock",
        //beachJPG: "ice beach",
        beachJPG: "icebeach_scaled",
        obstacleJPGs: ["berg1", "berg2"],
        wallTextureString: "ice wall",
        wallTextureVertString: "ice wall vert",
        partColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    )
    static let island3 = Island(
        backColor: UIColor(red: 84/255, green: 89/255, blue: 224/255, alpha: 1),
        obstacleColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        boatJPG: "boat",
        dockJPG: "dock",
        //beachJPG: "sunset beach",
        beachJPG: "sunsetbeach_scaled",
        obstacleJPGs: ["sunset orb"],
        wallTextureString: "sunset wall",
        wallTextureVertString: "sunset wall vert",
        partColor:  UIColor(red: 245/255, green: 183/255, blue: 178/255, alpha: 1)

    )
    static let island4 = Island(
        backColor: UIColor(red: 129/255, green: 184/255, blue: 226/255, alpha: 1),
        obstacleColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        boatJPG: "boat",
        dockJPG: "dock",
        //beachJPG: "city beach",
        beachJPG: "citybeach_scaled",
        obstacleJPGs: ["gondola", "gondola empty"],
        wallTextureString: "city wall",
        wallTextureVertString: "city wall vert",
        partColor: UIColor(red: 228/255, green: 234/255, blue: 221/255, alpha: 1)

    )
    static let island5 = Island(
        backColor: UIColor(red: 30/255, green: 104/255, blue: 150/255, alpha: 1),
        obstacleColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        boatJPG: "boat",
        dockJPG: "dock",
        //beachJPG: "lighthouse beach",
        beachJPG: "lighthousebeach_scaled_1",
        obstacleJPGs: ["rock1", "rock2"],
        wallTextureString: "rock wall",
        wallTextureVertString: "rock wall vert",
        partColor:UIColor(red: 155/255, green: 167/255, blue: 140/255, alpha: 1)
    )
}

