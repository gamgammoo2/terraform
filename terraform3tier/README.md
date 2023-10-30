10/27
https://github.com/DhruvinSoni30/Terraform-AWS-3tier-Architecture/tree/main
웨스트쪼꼬미 님의 추천으로 이분의 깃에서 코드를 들고와 써 만들어 보겠음.  fork 해도 되지만 직접 따라서 만들어나가는 것도 의미가 있다고 생각함.

1. vpc.tf 만들고 코드 복붙
<!-- 2. 새 폴더 내에서 terraform init 함 -->
3. subnet.tf 만들고 코드 복붙(퍼블릭과 프라이빗 서브의 혼합으로 이루어진 프론트와 백엔드를 위한 6개의 서브넷)
4. igw.tf(internet gateway)
5. route_table_public.tf(route table 생성) 
6. ec2 생성
7. web_sg.tf(security Group for frontend tier)
8. database_sg.tf ( security group for database tier)
9. alb.tf(application Load Balancer)
10. rds.tf( rds instance) -> username 과 password 바꿔야함.
11. outputs.tf -> application load balancer의 DNS 를 얻을 수 있음.
12. var.tf(variable을 위한 파일)
13. data.sh (user_data)

근데 뭐 리드미 있는거 그대로 복사해서 붙였는데 init 및 plan에서 자꾸만 error 짜잘짜잘 틀려서 남.(west씨의 코드와 비교해봄...)
Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: Invalid provider configuration
│
│ Provider "registry.terraform.io/hashicorp/aws" requires explicit configuration. Add a provider block to the root  
│ module and configure the provider's required arguments as described in the provider documentation.
│
╵
╷
│ Error: Invalid AWS Region: 
│
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on <empty> line 0:
│   (source code not available)
│
╵
이런 에러가 발생... 
해결 방법은?
한 깃허브 이슈에서 region에 abc 구분없이 그냥 입력하라고 함. 일단 해봄.(subnet) -> 일단 안되는데
혹시 몰라서 aws configure에서 key와 access key 입력후에 region으로 ap-northeast-2 입력후;;;;; plan하니까 된다 미쳤다ㅎㅎㅎㅎ 어제 밤에 설마..하면서 생각했었는데...ㅜ 이렇게 될 줄이야... 진즉 해볼걸 싶었다. 
apply 했다. -> 또 에러났다. 음. 아까 subnet에서 region에 abcd 지운게 문제인 것 같다. 되돌려놓고 다시 실행.