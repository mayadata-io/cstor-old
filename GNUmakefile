# Specify the date o build
BUILD_DATE = $(shell date +'%Y%m%d%H%M%S')

all: cstor-main-image

cstor-build:
	@echo "----------------------------"
	@echo "--> cstor-build		   "
	@echo "----------------------------"
	@sh cstor-container

cstor-main-image: cstor-build
	@echo "----------------------------"
	@echo "--> cstor-main-image         "
	@echo "----------------------------"
	@sudo docker build -f Dockerfile.maincontainer -t openebs/cstor-main-container:ci --build-arg BUILD_DATE=${BUILD_DATE} .       
	@sh push

prerequisites:
	@echo "----------------------------"
	@echo "--> Installing cstor-prerequisites "
	@echo "----------------------------"
	@sh cstor-prerequisites

