root="/Users/moderato/Downloads/"
cnn="resnet-32" # Options: "idsia", "resnet-20", "resnet-32"
size_xy=64
dataset="GT"
epoch=25
batch=64
preprocessing="clahe" # 0 for none, 1 for 1-sigma, 2 for 2-sigma, 3 for clahe

export OMP_NUM_THREADS=4
export KMP_AFFINITY=compact,1,0,granularity=fine # For neon

python TrafficBench.py --root $root --network_type $cnn --resize_side $size_xy --dataset $dataset --epoch_num $epoch --batch_size $batch --preprocessing $preprocessing --device cpu --backends tensorflow --frameworks Keras