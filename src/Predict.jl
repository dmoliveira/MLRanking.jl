function predict_ranklib(test_file, model_file, predict_file, norm, metric)
    temp_file = string("/tmp/", hex(round(Int, rand() * 1e16)), ".tmp")
    command = `
        java -jar $RANKLIBJAR
            -sparse
            -load $model_file
            -rank $test_file
            -score $temp_file
            -metric2T $metric`
    command = !isempty(norm)? `$command -norm $norm` : command
    run(command)
    println("Generated temp file $temp_file")
    to_prediction_file(temp_file, predict_file)
end

to_prediction_file(input_file, output_file) = run(pipeline(`cut -f3 -d$'\t' $input_file`, stdout=output_file))

predict_mart(test_file, model_file, predict_file; norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP") = predict_ranklib(test_file, model_file, predict_file, norm, metric)
predict_ranknet(test_file, model_file, predict_file; norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP") = predict_ranklib(test_file, model_file, predict_file, norm, metric)
predict_rankboost(test_file, model_file, predict_file; norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP") = predict_ranklib(test_file, model_file, predict_file, norm, metric)
predict_adarank(test_file, model_file, predict_file; norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP") = predict_ranklib(test_file, model_file, predict_file, norm, metric)
predict_coordinate_ascent(test_file, model_file, predict_file; norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP") = predict_ranklib(test_file, model_file, predict_file, norm, metric)
predict_lambdamart(test_file, model_file, predict_file; norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP") = predict_ranklib(test_file, model_file, predict_file, norm, metric)
predict_listnet(test_file, model_file, predict_file; norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP") = predict_ranklib(test_file, model_file, predict_file, norm, metric)
predict_randomforest(test_file, model_file, predict_file; norm=NORMALIZE_FEATURE_VECTORS_NO_NORM, metric="MAP") = predict_ranklib(test_file, model_file, predict_file, norm, metric)
predict_svmrank(test_file, model_file, predict_file) = run(`svm_rank_classify $test_file $model_file $predict_file`)
predict_svmmap(test_file, model_file, predict_file) = run(`svm_map_classify $test_file $model_file $predict_file`)
