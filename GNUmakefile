# Specify the date o build
BUILD_DATE = $(shell date +'%Y%m%d%H%M%S')

all: cstor-base-image cstor-basetest-image cstor-pool-image cstor-istgt-image

cstor-build:
	@echo "----------------------------"
	@echo "--> cstor-build		   "
	@echo "----------------------------"
	@sh cstor-container

cstor-base-image: cstor-build
	@echo "----------------------------"
	@echo "--> cstor-base-image         "
	@echo "----------------------------"
	@sudo docker build -f Dockerfile.Baseimage -t openebs/cstor-base:ci --build-arg BUILD_DATE=${BUILD_DATE} .       
	IMAGE_REPO=openebs/cstor-base ./push

cstor-pool-image:
	@echo "----------------------------"
	@echo "--> cstor-pool-image         "
	@echo "----------------------------"
	@sudo docker build -f Dockerfile.Poolimage -t openebs/cstor-pool:ci --build-arg BUILD_DATE=${BUILD_DATE} .
	IMAGE_REPO=openebs/cstor-pool ./push

cstor-istgt-image:
	@echo "----------------------------"
	@echo "--> cstor-istgt-image         "
	@echo "----------------------------"
	@sh cstor-istgt
	@sudo docker build -f Dockerfile.Istgtimage -t openebs/cstor-istgt:ci --build-arg BUILD_DATE=${BUILD_DATE} .
	IMAGE_REPO=openebs/cstor-istgt ./push

cstor-basetest-image:
	@echo "----------------------------"
	@echo "--> cstor-baseshared-image         "
	@echo "----------------------------"
	@sudo docker build -f Dockerfile.BaseTestImage -t openebs/cstor-test:ci --build-arg BUILD_DATE=${BUILD_DATE} .
	IMAGE_REPO=openebs/cstor-test ./push
