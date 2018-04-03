# Specify the date o build
BUILD_DATE = $(shell date +'%Y%m%d%H%M%S')

all: cstor-base-image cstor-basetest-image cstor-pool-image

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
	@sh push-baseimage

cstor-pool-image:
	@echo "----------------------------"
	@echo "--> cstor-pool-image         "
	@echo "----------------------------"
	@sudo docker build -f Dockerfile.Poolimage -t openebs/cstor-pool:ci --build-arg BUILD_DATE=${BUILD_DATE} .
	@sh push-poolimage

cstor-basetest-image:
	@echo "----------------------------"
	@echo "--> cstor-baseshared-image         "
	@echo "----------------------------"
	@sudo docker build -f Dockerfile.BaseTestImage -t openebs/cstor-test:ci --build-arg BUILD_DATE=${BUILD_DATE} .
	@sh push-testimage

prerequisites:
	@echo "----------------------------"
	@echo "--> Installing cstor-prerequisites "
	@echo "----------------------------"
	@sh cstor-prerequisites

