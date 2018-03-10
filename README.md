# TrafficSignBench
A benchmark for deep learning frameworks on traffic sign recognition task

## Usage:
* Download the code and change working directory to the folder.
```bash
git clone https://github.com/owensgroup/TrafficSignBench.git
cd TrafficSignBench
```
* Prepare Dataset. Currently only the GTSRB dataset is supported.
```bash
export DATASET_ROOT=/path/of/your/choice
./prepare_dataset.sh
```

* Run the benchmark. Change the setting in the script file if necessary.
```bash
./bench_script.sh
```
## Bugs to be fixed
* Neon support on CUDA 9 + cuDNN v7.
* MXNet and PyTorch generate "out of memory" bugs when they are launched after any other frameworks.
