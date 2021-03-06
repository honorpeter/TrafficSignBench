model_name=$1
batch=$2
precision=$3
if [ -z "$model_name" ]
then
	# model_name="ResNet20"
	model_name="MobileNetV2"
fi
if [ -z "$batch" ]
then
	batch=1
fi
if [ -z "$precision" ]
then
	precision="float"
fi
if [ "$model_name" == "VGG16" ] || [ "$model_name" == "MobileNet" ] || [ "$model_name" == "MobileNetV2" ] || [ "$model_name" == "ResNet18" ] || [ "$model_name" == "ResNet50" ] || [ "$model_name" == "SqueezeNet11" ] ; then 
	type="detection"
else
	type="classification"
fi

echo "**********"
printf $"Model: $model_name\nbatch = ${batch}, precision = ${precision}, type = ${type}\n"
echo "**********"

# Use R3 for now as both R4 & R5 have a bug
cd $OPENVINO_ROOTDIR/deployment_tools/model_optimizer_R3/install_prerequisites
# ./install_prerequisites.sh tf venv
source ../venv/bin/activate

if [ "$type" == "detection" ]; then
	cd ../gtsdb/tf/${model_name}
	python ../../../mo_tf.py --input_model frozen_inference_graph.pb --output="detection_boxes,detection_scores,num_detections" --data_type $precision --reverse_input_channels --input_shape [$batch,300,510,3] --tensorflow_object_detection_api_pipeline_config pipeline.config --tensorflow_use_custom_operations_config ../../../extensions/front/tf/ssd_v2_support.json | grep abc
else # classification
	# GTSRB
	cd ../classification/tf
	if [ "$model_name" == "IDSIA" ]; then
		model=idsia_48by48.pb
		python3 ../../mo_tf.py --input_model $model -b $batch --input=idsia/input_placeholder --output=idsia/probs --data_type $precision --scale 255 | grep -e abc
	elif [ "$model_name" == "ResNet20" ]; then
		model=resnet-20_32by32.pb
		python3 ../../mo_tf.py --input_model $model -b $batch --input=resnet-20/input_placeholder --output=resnet-20/probs --data_type $precision --scale 255 | grep -e abc
	else # ResNet32
		model=resnet-32_64by64.pb
		python3 ../../mo_tf.py --input_model $model -b $batch --input=resnet-32/input_placeholder --output=resnet-32/probs --data_type $precision --scale 255 | grep -e abc
	fi
fi


