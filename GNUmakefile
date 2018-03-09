# Specify the date o build
BUILD_DATE = $(shell date +'%Y%m%d%H%M%S')

all: cstor-main-image

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
	@sh push

prerequisites:
	@echo "----------------------------"
	@echo "--> Installing cstor-prerequisites "
	@echo "----------------------------"
	@sh cstor-prerequisites

