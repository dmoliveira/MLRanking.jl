RANKLIBJAR  = get(ENV, "MLR_RANKLIBJAR", "")
SVMRANK     = get(ENV, "MLR_SVMRANK", "")
SVMMAP      = get(ENV, "MLR_SVMMAP", "")

isempty(RANKLIBJAR) && warn("Environment variable MLR_RANKLIBJAR not defined. You could not use RankLib algorithms until set the correct path. See documentation to install it.")
isempty(SVMRANK) && warn("Environment variable MLR_SVMRANK not defined. You could not use SVMRank algorithm until set the correct path. See documentation to install it.")
isempty(SVMMAP) && warn("Environment variable MLR_SVMMAP not defined. You could not use SVMMAP algorithm until set the correct path. See documentation to install it.")

ALGORITHM_RANKLIB_MART              = :MART
ALGORITHM_RANKLIB_RANKNET           = :RankNet
ALGORITHM_RANKLIB_RANKBOOST         = :RankBoost
ALGORITHM_RANKLIB_ADARANK           = :AdaRank
ALGORITHM_RANKLIB_COORDINATE_ASCENT = :CoordinateAscent
ALGORITHM_RANKLIB_LAMBDA_MART       = :LambdaMART
ALGORITHM_RANKLIB_LISTNET           = :ListNet
ALGORITHM_RANKLIB_RANDOM_FOREST     = :RandomForest

function get_ranklib_algorithm(algorithm)
    algorithm == ALGORITHM_RANKLIB_MART && return 0
    algorithm == ALGORITHM_RANKLIB_RANKNET && return 1
    algorithm == ALGORITHM_RANKLIB_RANKBOOST && return 2
    algorithm == ALGORITHM_RANKLIB_ADARANK && return 3
    algorithm == ALGORITHM_RANKLIB_COORDINATE_ASCENT && return 4
    algorithm == ALGORITHM_RANKLIB_LAMBDA_MART && return 6
    algorithm == ALGORITHM_RANKLIB_LISTNET && return 7
    algorithm == ALGORITHM_RANKLIB_RANDOM_FOREST && return 8
end

NORMALIZE_FEATURE_VECTORS_NO_NORM = ""
NORMALIZE_FEATURE_VECTORS_SUM     = "sum"
NORMALIZE_FEATURE_VECTORS_ZSCORE  = "zscore"
NORMALIZE_FEATURE_VECTORS_LINEAR  = "linear"
NORMALIZE_FEATURE_VECTORS = [NORMALIZE_FEATURE_VECTORS_NO_NORM, NORMALIZE_FEATURE_VECTORS_SUM,
                             NORMALIZE_FEATURE_VECTORS_ZSCORE, NORMALIZE_FEATURE_VECTORS_LINEAR];
