using MLRanking
using Base.Test

# write your own tests here
@test 1 == 1

# Auxiliary Functions
function test_function(func, args...; kwargs...)
    try
        func(args...; kwargs...)
        return true
    catch
        return false
    end
end

# Constants
SAMPLE_DATA    = "../data/sample.dat"
MODEL_DATA     = "/tmp/tmp.mdl"
PREDICT_DATA   = "/tmp/predict.tsv"
MLR_RANKLIBJAR = "MLR_RANKLIBJAR"
MLR_SVMRANK    = "MLR_SVMRANK"
MLR_SVMMAP     = "MLR_SVMMAP"

# Test Environment
@test !isempty(get(ENV, MLR_RANKLIBJAR, ""))
@test !isempty(get(ENV, MLR_SVMRANK, ""))
@test !isempty(get(ENV, MLR_SVMMAP, ""))

# Test L2R MART Algorithm Train/Predict
isfile(MODEL_DATA) && rm(MODEL_DATA)
@test test_function(train_mart, SAMPLE_DATA, MODEL_DATA; trees=10, leaves=5, learning_rate=.05)
@test isfile(MODEL_DATA)
@test test_function(predict_mart, SAMPLE_DATA, MODEL_DATA, PREDICT_DATA)
rm(MODEL_DATA)

# Test L2R RankNet Algorithm Train/Predict
isfile(MODEL_DATA) && rm(MODEL_DATA)
@test test_function(train_ranknet, SAMPLE_DATA, MODEL_DATA; num_epochs=10, node=2)
@test isfile(MODEL_DATA)
@test test_function(predict_ranknet, SAMPLE_DATA, MODEL_DATA, PREDICT_DATA)
rm(MODEL_DATA)

# Test L2R RankBoost Algorithm Train/Predict
isfile(MODEL_DATA) && rm(MODEL_DATA)
@test test_function(train_rankboost, SAMPLE_DATA, MODEL_DATA; num_rounds=10)
@test isfile(MODEL_DATA)
@test test_function(predict_rankboost, SAMPLE_DATA, MODEL_DATA, PREDICT_DATA)
rm(MODEL_DATA)

# Test L2R AdaRank Algorithm Train/Predict
isfile(MODEL_DATA) && rm(MODEL_DATA)
@test test_function(train_adarank, SAMPLE_DATA, MODEL_DATA; num_rounds=10, max_feature_selected=1)
@test isfile(MODEL_DATA)
@test test_function(predict_adarank, SAMPLE_DATA, MODEL_DATA, PREDICT_DATA)
rm(MODEL_DATA)

# Test L2R Coordinate Ascent Algorithm Train/Predict
isfile(MODEL_DATA) && rm(MODEL_DATA)
@test test_function(train_coordinate_ascent, SAMPLE_DATA, MODEL_DATA; num_random_restarts=2, num_iterations=5)
@test isfile(MODEL_DATA)
@test test_function(predict_coordinate_ascent, SAMPLE_DATA, MODEL_DATA, PREDICT_DATA)
rm(MODEL_DATA)

# Test L2R LambdaMART Algorithm Train/Predict
isfile(MODEL_DATA) && rm(MODEL_DATA)
@test test_function(train_lambdamart, SAMPLE_DATA, MODEL_DATA; trees=10, leaves=10)
@test isfile(MODEL_DATA)
@test test_function(predict_lambdamart, SAMPLE_DATA, MODEL_DATA, PREDICT_DATA)
rm(MODEL_DATA)

# Test L2R ListNet Algorithm Train/Predict
isfile(MODEL_DATA) && rm(MODEL_DATA)
@test test_function(train_listnet, SAMPLE_DATA, MODEL_DATA; num_epochs=10)
@test isfile(MODEL_DATA)
@test test_function(predict_listnet, SAMPLE_DATA, MODEL_DATA, PREDICT_DATA)
rm(MODEL_DATA)

# Test L2R Random Forest Algorithm Train/Predict
isfile(MODEL_DATA) && rm(MODEL_DATA)
@test test_function(train_randomforest, SAMPLE_DATA, MODEL_DATA; num_bags=4, feature_sampling_rate=1, leaves=5, min_leaf_support=1)
@test isfile(MODEL_DATA)
@test test_function(predict_randomforest, SAMPLE_DATA, MODEL_DATA, PREDICT_DATA)
rm(MODEL_DATA)

# Test L2R SVMRank Algorithm Train/Predict
# isfile(MODEL_DATA) && rm(MODEL_DATA)
# @test test_function(train_svmrank, SAMPLE_DATA, MODEL_DATA)
# @test isfile(MODEL_DATA)
# @test test_function(predict_svmrank, SAMPLE_DATA, MODEL_DATA, PREDICT_DATA)
# rm(MODEL_DATA)

# Test L2R SVMMAP Algorithm Train/Predict
# isfile(MODEL_DATA) && rm(MODEL_DATA)
# @test test_function(train_svmmap, SAMPLE_DATA, MODEL_DATA)
# @test isfile(MODEL_DATA)
# @test test_function(predict_svmmap, SAMPLE_DATA, MODEL_DATA, PREDICT_DATA)
# rm(MODEL_DATA)
