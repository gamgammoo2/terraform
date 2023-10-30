# jenkins-pipeline-deploy-to-eks
# Project Name: End to end deployment of Applications to Kubernetes using a Jenkins CI/CD Pipeline
# Steps for the project

## 1. Create a Keypair that matches your keypair
## 2. Create a Jenkins Server with all the dependencies, libraries and packagies needed.
## 2. Once completed, access the Jenkins server and Set it up
## 4. Run the jenkins-pipeline-deploy-to-eks to create Kubernetes Cluster, create deployments and Services
## 5. Test that the application is running 
## 6. Destroy infrastructure

10/28
내친구 서씨가 젠킨스 해보라고해서 해보았다. dicd 툴의 최강자라고하던데 어떤 대단한 놈인지 기대된다. 턱시도 웨이터인데 힘순찐인가보다. 젠킨스 _ kubernetes aws terraform 으로 유튜브에 키워드 검색하니 primus leaning 이라는 채널의 수업을 선택했다.
우선 그분의 깃허브에서 클론해온게 github.com/Primus19 이 코드들이다.
우선 terraform-code 어쩌구 파일에서 backend.tf에 region을 ap-northeast-2로 바꾸고 jenkins-server.tf에서 인스턴스의 키페어를 내껄로 바꾸었다. 
다른 파일들도 보면서 provider에서 region을 ap-northeast-2로 마찬가리고 변경했다.
그냥 보면서 region은 바꿔주면 된다. 8080포트는 jenkins를 위한 포트로 열어뒀단다. 
terraform-code-to-create-jenkins-server 이 파일안의 내용은 jenkins 서버를 위한 ec2 구축의 tf 코드들이란다.

이 폴더 내에서 terraform init 하니까 
Failed to get existing workspaces: Unable to list objects in S3 bucket "primuslearning-app": operation error S3: ListObjectsV2, https response error StatusCode: 301, RequestID: PB222KKCSRDWZ3A3, HostID: EgwtJcnP28ZrK30zEbmGVZ9fcaBGZkJbnjqiUa59Is/7EjK5e7m/zUk9lwE7Vwe0f8e8adH4SBg=, requested bucket from "ap-northeast-2", actual location "us-east-1"
이런 에러가 발생했다. 그래서 bucket이름을 내 아이디 내의 s3에 있는 이름으로 우선 바꿔보았다. -> 그러니까 된다. 폼미쳐버렸다.

terraform apply 하고 나오는
Outputs:

ec2_public_ip = "3.35.51.2" 이거 keeping 하래(어차피 나중에 destroy 할꺼라서 기록해 둔다.)

그리고 인스턴스 생성됬다면 크롬 열어서 3.35.51.2:8080으로 jenkins server를 가진 ec2로 들어가보자이-> 안뜸 아무것도...
그래서 jenkins-server가 깔고있는 중인건지 싶어서 putty로 접속후, htop 설치해서 htop으로 확인해보는 절차를 진행함. -> 뭐 어디서 배운건 있어서 썼지만 모르겠고 뭘 설치중인건 없는 듯 함. + systemctl status jenkins 했는데 jenkins.service 찾을 수 없데요.
일단 terraform destroy 함.

안되서 https://medium.com/@raguyazhin/install-jenkins-on-amazon-linux-ec2-instance-using-terraform-1a6bc35bacaa 이 블로그의 글을 이용해 terraform을 활용한 jenkins server 설치를 해보려고한다. 우선 새로 terraform-jenkins-server 폴더를 만들어준다
이것도 안되서 (자꾸 remote-exec provisioner error 이 에러가 발생) ec2.tf에서 provisioner의 remote-exec에 inline을 terraform-code-to-어쩌구 쨌든 여기 이 폴더 내에 있는 jenkins-server-script.sh에 있는 내용으로 바꿔서 넣고 다시 init 해봄. 그러니까 일단 에러없이 일단 되긴 함. ㅜㅜ 그러니까 퍼블릭 ip + 8080 하니까 jenkins server가 떴다!!

일단 ssh -i .\.ssh\terraform.pem ec2-user@13.125.7.72 이렇게해서 접속 후 jenkins-server에 표시된 경로를 cat해서 보면 (물론 sudo 붙여야함 root계정이 아니니깐) 패스워드가 보인다 그걸 복사해서 젠킨스서버에 붙여넣으면 된다. 이후 install suggested plugins 누름(필요한거 다운해줌)
이후 manage jenkins에서 credentials 누르고 나오는 system의 domain에 global을 클릭
그러면 add credentials를 할 수 있음.
처음으로는, github용 크레덴셜 만들기
두번째로는 secret text로 aws credential 만들기 (id랑 key랑 각각 만들기)

이제 jenkins-pipeline-deploy~ 파일에서 할거임
terraform 폴더 안에서 파일들 보면서 수정할 것 수정하고(region 특히..)
그리고 젠킨스 파일을 보면 pipeline을 만드는 로직들이 구현되어있음.(EKS를 만들고 EKS에 deploy 하는것 까지.(아주 심플한 nginx 배포용 yaml 파일임.))

일단 깃 리포 만들어서 상위 폴더에 깃 클론을 하는데. 나는 이미 깃 클론을 상위폴더에 해둬서 안했음.
쨋든 jenkins-pipeline~ 이 폴더 내에서 git add . / git commit -m "<커밋메시지>" / git push 한다 (알쥬?)
이후 github 들어가서 방금 푸쉬한 레포의 파일로 들어가서 주소를 복사한다. "https://github.com/gamgammoo2/terraform/tree/main/jenkins-pipeline-deploy-to-eks" 나는 위와 같음
젠킨스 페이지로 들어가서 dashboard에서 뉴 아이템에 들어가고 field 이름 채워주고 pipeline 눌러주고 ok.

SCM(source control manager)로 definition을 바꿈. SCM에서 git으로 바꾸고, url은 방금 복사한 경로를 붙여넣는다. credential은 아까전에 만들었던 git용 으로 선택한다. -> 이랬는데 자꾸 url에서 에러가 나서 그냥 깃리포 새로 만들고 클론하고 거기에 커밋하려한다.(그것도 내 본계정으로만 되게끔 에러가 나서...결국 gamgammoo2로 했다.) 그리고 ok 누르면 우리는 pipeline을 생성한거다. ㅁㅊ 안됨ㅜㅜ하... https://blog.naver.com/rudnfskf2/221400958621 이 블로그 보면서 따라했는데 안되네... 울고싶다 흑흑