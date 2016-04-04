function train_ranklib(train_file, model_file, algorithm, extra_parameters; 
                       train_percentage=.85, norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP")
    command = `
         java -jar $RANKLIBJAR
         -sparse
         -train $train_file
         -save $model_file 
         -metric2t $metric
         -ranker $(get_ranklib_algorithm(algorithm))
         -tvs $train_percentage
         $extra_parameters`
    command =  !isempty(strip(norm))? `$command -norm $norm` : command
    return run(command)
end

function train_mart(train_file, model_file; trees=1000, leaves=10, learning_rate=.1, 
                    threshold_candidates=256, min_leaf_support=1, stop_early_validation=100,
                    train_percentage=.85, norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP")
    parameters  = `
        -tree $trees
        -leaf $leaves
        -shrinkage $learning_rate
        -tc $threshold_candidates
        -mls $min_leaf_support
        -estop $stop_early_validation`
    train_ranklib(train_file, model_file, ALGORITHM_RANKLIB_MART, parameters,
                  train_percentage=train_percentage, norm=norm, metric=metric)
end

function train_ranknet(train_file, model_file; num_epochs=100, layer=1, node=10, learning_rate=5e-5,
                       train_percentage=.85, norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP")
    parameters = `
        -epoch $num_epochs
        -layer $layer
        -node $node
        -lr $learning_rate`
    train_ranklib(train_file, model_file, ALGORITHM_RANKLIB_RANKNET, parameters,
                  train_percentage=train_percentage, norm=norm, metric=metric)
end

function train_rankboost(train_file, model_file; num_rounds=300, threshold_candidates=10,
                         train_percentage=.85, norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP")
    parameters = `
        -round $num_rounds
        -tc $threshold_candidates`
    train_ranklib(train_file, model_file, ALGORITHM_RANKLIB_RANKBOOST, parameters,
                  train_percentage=train_percentage, norm=norm, metric=metric)
end

function train_adarank(train_file, model_file; num_rounds=500, tolerance=.002,
                       max_feature_selected=5, istrain_without_strong_features=false,
                       train_percentage=.85, norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP")
    parameters = `
        -round $num_rounds
        -tolerance $tolerance
        -max $max_feature_selected`
    parameters = istrain_without_strong_features? parameters : `$parameters -noeq`
    train_ranklib(train_file, model_file, ALGORITHM_RANKLIB_ADARANK, parameters,
                  train_percentage=train_percentage, norm=norm, metric=metric)
end

function train_coordinate_ascent(train_file, model_file; num_random_restarts=5,
                                 num_iterations=25, tolerance=.001, regularization=.001,
                                 train_percentage=.85, norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP")
    parameters = `
        -r $num_random_restarts
        -i $num_iterations
        -tolerance $tolerance
        -reg $regularization`
    train_ranklib(train_file, model_file, ALGORITHM_RANKLIB_COORDINATE_ASCENT, parameters,
                  train_percentage=train_percentage, norm=norm, metric=metric)
end

function train_lambdamart(train_file, model_file;
                          trees=1000, leaves=10, learning_rate=0.1, 
                          threshold_candidates=256, min_leaf_support=1, early_stop_validation=100,
                          train_percentage=.85, norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP")
    parameters  = `
        -tree $trees
        -leaf $leaves
        -shrinkage $learning_rate
        -tc $threshold_candidates
        -mls $min_leaf_support
        -estop $early_stop_validation`
    train_ranklib(train_file, model_file, ALGORITHM_RANKLIB_LAMBDA_MART, parameters,
                  train_percentage=train_percentage, norm=norm, metric=metric)
end

function train_listnet(train_file, model_file; num_epochs=1500, learning_rate=1e-5,
                       train_percentage=.85, norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP")
    parameters = `
        -epoch $num_epochs
        -lr $learning_rate`
    train_ranklib(train_file, model_file, ALGORITHM_RANKLIB_LISTNET, parameters,
                  train_percentage=train_percentage, norm=norm, metric=metric)
end

function train_randomforest(train_file, model_file; num_bags=300, subsampling_rate=1.0,
                            feature_sampling_rate=.3, num_trees_bag=1, leaves=100, learning_rate=.1,
                            threshold_candidates=10, min_leaf_support=100, early_stop_validation=100,
                            train_percentage=.85, norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP")
    parameters = `
            -bag $num_bags
            -srate $subsampling_rate
            -frate $feature_sampling_rate
            -tree $num_trees_bag
            -leaf $leaves
            -shrinkage $learning_rate
            -tc $threshold_candidates
            -mls $min_leaf_support
            -estop $early_stop_validation`
    train_ranklib(train_file, model_file, ALGORITHM_RANKLIB_RANDOM_FOREST, parameters,
                  train_percentage=train_percentage, norm=norm, metric=metric)
end

function train_svmrank(train_file, model_file; tradeoff_train_error_margin=1e-1, 
                       kernel=0, lnorm=1, rescaleloss=2)
    command = `$SVMRANK/svm_rank_learn
        -c $tradeoff_train_error_margin
        -t $kernel
        -p $lnorm
        -o $rescaleloss
        $train_file $model_file`
    run(command)
end

function train_svmmap(train_file, model_file; tradeoff_train_error_margin=1e-1)
    temp_file = string("/tmp/", hex(round(Int, rand() * 1e16)), ".tmp")
    open(temp_file, "w") do data_index_file
        write(data_index_file, "$train_file")
    end
    command = `$SVMMAP/svm_map_learn -c $tradeoff_train_error_margin $temp_file $model_file`
    run(command)
    run(`rm $temp_file`)
end
