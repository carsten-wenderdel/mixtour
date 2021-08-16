import Foundation

/// The rawValue is the number of iterations the Monte Carlo player should use for evaluation.
/// Adjacent configs should lead to an ELO difference of 150.
/// According to https://en.wikipedia.org/wiki/Elo_rating_system
/// the weaker player should win 29.6615% of all games for a rating difference of 150,
/// the stronger player should win 70.3385% of all games.
/// After trying out various values for the number of iterations, these values work as an educated guess.
public enum MCPlayerConfig: Int, CaseIterable {

    case beginner1 = 45
    case beginner2 = 80
    case casualPlayer1 = 175
    case casualPlayer2 = 417
    case advanced1 = 1_000
    case advanced2 = 1_935
    case expert1 = 3_420
    case expert2 = 6_150
    case worldClass1 = 11_050

    public var eloRating: Int {
        switch self {
        case .beginner1:
            return 1000
        case .beginner2:
            return 1150
        case .casualPlayer1:
            return 1300
        case .casualPlayer2:
            return 1450
        case .advanced1:
            return 1600
        case .advanced2:
            return 1750
        case .expert1:
            return 1900
        case .expert2:
            return 2050
        case .worldClass1:
            return 2200
        }
    }
}


// These are the results of PlayerEvaluation.swift, letting different iteration values competing against each other.
// Goal is always to have an ELO difference of 150, the stronger player should win 70.3385% of all games.



// Vs 80. So we picked 45.

//        let player2 = MonteCarloPlayer(numberOfIterations: 46)
//        16112.0 iterations
//        combined: 69.61271102284012

//        let player2 = MonteCarloPlayer(numberOfIterations: 45)
//        8366.0 iterations
//        combined: 70.77456371025579

//        let player2 = MonteCarloPlayer(numberOfIterations: 41)
//        2245.0 iterations
//        combined: 74.26503340757239

//        let player2 = MonteCarloPlayer(numberOfIterations: 37)
//        2106.0 iterations
//        combined: 77.18423551756885



// Versus 175. So we picked 80

//        let player2 = MonteCarloPlayer(numberOfIterations: 80)
//        3027.0 iterations
//        combined: 70.34192269573836

//        let player2 = MonteCarloPlayer(numberOfIterations: 76)
//        3024.0 iterations
//        combined: 71.78406084656085

//        let player2 = MonteCarloPlayer(numberOfIterations: 73)
//        6112.0 iterations
//        combined: 72.0345222513089



// Versus 417. So we picked 175


//        let player2 = MonteCarloPlayer(numberOfIterations: 177)
//        3681.0 iterations
//        combined: 69.47840260798696

//        let player2 = MonteCarloPlayer(numberOfIterations: 176)
//        3009.0 iterations
//        combined: 69.8570953805251

        //        let player2 = MonteCarloPlayer(numberOfIterations: 175)
        //        4316.0 iterations
        //        combined: 70.51668211306766

//        let player2 = MonteCarloPlayer(numberOfIterations: 175)
//        2611.0 iterations
//        combined: 71.0455764075067

//        let player2 = MonteCarloPlayer(numberOfIterations: 174)
//        3006.0 iterations
//        combined: 70.60878243512974



// When competing against 1000 iterations. So we picked 417

//        let player2 = MonteCarloPlayer(numberOfIterations: 450)
//        450.0 iterations
//        combined: 69.55555555555556

//        let player2 = MonteCarloPlayer(numberOfIterations: 440)
//        1193.0 iterations
//        combined: 69.55155071248952

//        let player2 = MonteCarloPlayer(numberOfIterations: 430)
//        756.0 iterations
//        combined: 69.1137566137566

//        let player2 = MonteCarloPlayer(numberOfIterations: 420)
//        1014.0 iterations
//        combined: 71.00591715976331

//        let player2 = MonteCarloPlayer(numberOfIterations: 418)
//        1011.0 iterations
//        combined: 69.8813056379822
//
//        let player2 = MonteCarloPlayer(numberOfIterations: 417)
//        2015.0 iterations
//        combined: 70.03722084367246

//        let player2 = MonteCarloPlayer(numberOfIterations: 416)
//        2039.0 iterations
//        combined: 71.44433545855811

//        let player2 = MonteCarloPlayer(numberOfIterations: 415)
//        1078.0 iterations
//        combined: 69.68923933209648

//        let player2 = MonteCarloPlayer(numberOfIterations: 414)
//        2007.0 iterations
//        combined: 71.52466367713005

//        let player2 = MonteCarloPlayer(numberOfIterations: 413)
//        1134.0 iterations
//        combined: 71.05379188712521

//        let player2 = MonteCarloPlayer(numberOfIterations: 412)
//        1023.0 iterations
//        combined: 70.89442815249267

//        let player2 = MonteCarloPlayer(numberOfIterations: 410)
//        775.0 iterations
//        combined: 73.7741935483871

//        let player2 = MonteCarloPlayer(numberOfIterations: 400)
//        377.0 iterations
//        combined: 73.74005305039788



// Vs 1000 iterations reversed. So we picked 1935

//        let player1 = MonteCarloPlayer(numberOfIterations: 1850)
//        2671.0 iterations
//        combined: 67.62448521153127

//        let player1 = MonteCarloPlayer(numberOfIterations: 1880)
//        2787.0 iterations
//        combined: 68.9989235737352

//        let player1 = MonteCarloPlayer(numberOfIterations: 1890)
//        2507.0 iterations
//        combined: 68.53809333865178

//        let player1 = MonteCarloPlayer(numberOfIterations: 1900)
//        2625.0 iterations
//        combined: 70.67619047619047

//        let player1 = MonteCarloPlayer(numberOfIterations: 1920)
//        2880.0 iterations
//        combined: 70.13020833333333

//        let player1 = MonteCarloPlayer(numberOfIterations: 1940)
//        2843.0 iterations
//        combined: 69.85578614139993

//        let player1 = MonteCarloPlayer(numberOfIterations: 1950)
//        2670.0 iterations
//        combined: 70.72097378277154

//        let player1 = MonteCarloPlayer(numberOfIterations: 1970)
//        2522.0 iterations
//        combined: 71.25297383029341

//        let player1 = MonteCarloPlayer(numberOfIterations: 2000)
//        1508.0 iterations
//        combined: 71.93302387267904

//        let player1 = MonteCarloPlayer(numberOfIterations: 2200)
//        467.0 iterations
//        combined: 74.30406852248395



// VS 1935 (other way around). So we picked 3420

//        let player1 = MonteCarloPlayer(numberOfIterations: 3200)
//        3217.0 iterations
//        combined: 68.6897730805098

//        let player1 = MonteCarloPlayer(numberOfIterations: 3300)
//        2116.0 iterations
//        combined: 68.39555765595463

//        let player1 = MonteCarloPlayer(numberOfIterations: 3380)
//        2411.0 iterations
//        combined: 69.28660306926587

//        let player1 = MonteCarloPlayer(numberOfIterations: 3400)
//        2265.0 iterations
//        combined: 71.18101545253863

//        let player1 = MonteCarloPlayer(numberOfIterations: 3415)
//        2562.0 iterations
//        combined: 70.51131928181108

//        let player1 = MonteCarloPlayer(numberOfIterations: 3450)
//        2031.0 iterations
//        combined: 70.64254062038405

//        let player1 = MonteCarloPlayer(numberOfIterations: 3500)
//        2095.0 iterations
//        combined: 71.67064439140812

//        let player1 = MonteCarloPlayer(numberOfIterations: 3800)
//        2139.0 iterations
//        combined: 73.35203366058906



// VS 3420 (other way around). So we picked 6150

//        let player1 = MonteCarloPlayer(numberOfIterations: 6000)
//        2079.0 iterations
//        combined: 69.36026936026936

//        let player1 = MonteCarloPlayer(numberOfIterations: 6150)
//        5735.0 iterations
//        combined: 70.85876198779425

//        let player1 = MonteCarloPlayer(numberOfIterations: 6200)
//        2750.0 iterations
//        combined: 70.38181818181818

//        let player1 = MonteCarloPlayer(numberOfIterations: 6250)
//        15600.0 iterations
//        combined: 70.82211538461539


// VS 6150 (other way around). So wie picked 11050

//        let player1 = MonteCarloPlayer(numberOfIterations: 11050)
//        2185.0 iterations
//        combined: 70.2974828375286
