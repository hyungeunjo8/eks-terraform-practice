# EKS-Terraform Practice

## 목적
EKS 및 기타 AWS 인프라 요소를 Terraform으로 구성한다.

## 구성 내역
- 체크 박스된 것은 EKS pod에서 동작 확인
- [x] vpc
- [x] eks
- [x] msk
- [x] s3
- [x] dynamo
- [ ] sqs
- [x] cache
- [x] memorydb
- [ ] rds
- [x] secretmanager

## 실행 방법
1. 이름, IP가 중복될 수 있어, 아래 파일의 '## 변수 변경할 내역들'들 변경
- ./terraform.tfvars
- alb_serviceaccount/terraform.tfvars

2. vpc, eks, msk 등 인프라 생성
- terraform init
- terraform apply

3. eks의 alb, serviceaccount 설정
- aws eks update-kubeconfig --name [terraform.tfvar에서 설정한 eks 이름]
- cd alb_serviceaccount
- terraform init
- terraform apply

## EKS에서 테스트할 수 있는 Repository
- 통합 테스트 프로젝트 구성중
