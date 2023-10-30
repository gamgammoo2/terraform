# terraform
이게 로컬에서 했는데, 깃에 올리니까 나도 모르는 이름으로 contribute 되어서 올라간다... 왜일까...? 
-> 확인해보니 로컬 깃은 다른 유저로 되어있는것 같다...

유튜버 이재홍tv님의 테라폼으로 ec2 생성 및 docker 설치 영상보고 따라서 해보았다.
1. aws cli + IAM access key(aws configure)
2. choco로 테라폼 설치
3. code . 으로 vscode 실행 + terraform extension 설치
4. terraform aws 틀 복사해와서 붙여넣기
5. resource로 ec2, security_groups 생성, data로 vpc 받아오는 코드 작성
6. terraform init 실행 
7. terraform plan으로 틀린거 없는지 확인
8. 이상 없을 시 terraform apply로 실행
9. putty 실행(ppk로 키를 발급받았었음.) -> 접속 확인
10. docker 설치를 위해 resource "aws_instance" ~~ 부분을 주석 처리 후 terraform apply로 실행-> ec2 종료됨(중지 아님)
11. user_data를 instance 상에 aws cloud init 을 통해서 넣음(user_data는 yaml파일로 생성하고, https://get.docker.com/에서 설치 cmd 부분만 복사해서 설치 cmd 부분만 넣어줌.)
12. main.tf에서 주석 처리한거 다시 없애고, user_data는 경로를 읽어와 실행하게 함.
13. terraform plan -> terraform apply 실행
14. putty로 접속해서 docker가 설치되었는지 확인
15. 다됬으면 terraform destroy로 전부 다 없애버린다. -> 실습 후 다 없애버리는게 좋다(안그러면 돈 나간다...)

cf) putty 프롬프트 색상을 초록색으로 바꾸기 위해 $export PS1="\e[0;32m[\u@\h \W]\$ \e[m " 을 치면 된다
-> 참고사이트 : http://web.bluecomtech.com/saltfactory/blog.saltfactory.net/linux/change-prompt-in-terminal.html


10.24
aws master ami를 생성해서 이 ami를 이용해 인스턴스를 생성하면 만들 수 있지않을까 싶었으나...
깃에 올리고 이러면 보안적으로 내 정보들이 들어가있는 인스턴스라 이런식으로하면 위험할 것 같았다
일단 git에만 안올리면 "해볼 수 는 있지"하고 ami랑 instance_type t2.2xlarge로 바꾸고 terraform plan -> apply 하니까 
"Error: creating EC2 Instance: VcpuLimitExceeded: You have requested more vCPU capacity than your current vCPU limit of 32 allows for the instance bucket that the specified instance type belongs to. Please visit http://aws.amazon.com/contact-us/ec2-request to request an adjustment to this limit." 에러가 발생했다.
인터넷에 찾아보니까 "vCPU 개수"를 증량하면 된다고한다.
cf) https://velog.io/@rockwellvinca/AWS-vCPU%EA%B0%9C%EC%88%98-%EB%8A%98%EB%A6%AC%EA%B8%B0-vCPU-%EC%98%A8%EB%94%94%EB%A7%A8%EB%93%9C-%EC%A0%9C%ED%95%9C-%EB%8A%98%EB%A6%AC%EA%B8%B0

"vCPU 제한은 Service Quotas에서 확인"
근데 이건 service에서 on-demand검색해서 확인하면 나에게 할당된 ec2 생성?량을 보여주는 것 같음....

온디맨드 표준(A, C, D, H, I, M, R, T, Z)의 기본 vCPU 한도 : 인스턴스 사용 시	1152 vCPU(Virtual CPU)라고함
그리고 현재 서울 리전에 생성되고 실행중인 ec2들이 2xlarge 3개(vcpu=8 *3)  micro 1개(vcpu=1 *1) -> 지금 현재 총 25의 vcpu인데 
본인은 지금 32의 vcpu가 할당되어있으므로... 2xlarge를 하나 더 생성하면 33이 되므로 초과되는 상황임.
->그래서 결국 t3.small로 해서 만드니까 만들어짐.
cf ) https://aws.amazon.com/ko/ec2/faqs/#EC2_On-Demand_Instance_limits

참고로 가상화 환경의 용어들에 대해 설명을 잘해둔 사이트가 있어서 들고옴
http://cloudrain21.com/terms-about-virtualization





