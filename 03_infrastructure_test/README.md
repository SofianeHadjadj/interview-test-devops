# Infrastructure

The "infra as Code" is one of the technologies on which I would like the most evolved because I have already worked with Terraform and Ansible on AWS for school and on GCP for personal projects but I would like to devote more time to it .

Regarding the project that I present, it was carried out for Google Cloud Platform, quite simply because I have an account on it.

Before starting the first thing to do is to export the credential.json:

`export GOOGLE_CREDENTIALS_APPLICATION=/your_path/key.json`

(`SET` instead of `export` if you are on Windows)

After that, run the basic terraform commands:

- `terraform init`
- `terraform apply`

To check that everything is in order.

You will then be asked to enter 3 pieces of information:

- The name of your project on GCP
- Region you want
- And the area

![Setting variables](https://raw.githubusercontent.com/SofianeHadjadj/interview-test-devops/master/03_infrastructure_test/images/screen_terra1.png)

After that if there is no error you can launch the command `terraform apply` by giving us the 3 previous informations.

The script is then responsible for creating the following elements:

- The rules for the ParFeu (authorization of port 80)
- The establishment of a DNS
- Setting up an HTTP proxy
- The implementation of SSL certificates
- The establishment of a static storage bucket
- The establishment of a group of instances
- The establishment of 2 VMs in the instance group:
    - 1 CentOS
    - 1 Ubuntu
- Setting up an Nginx server in each VM

![Screen GCP 1](https://raw.githubusercontent.com/SofianeHadjadj/interview-test-devops/master/03_infrastructure_test/images/screen_terra2.png)

![Screen GCP 2](https://raw.githubusercontent.com/SofianeHadjadj/interview-test-devops/master/03_infrastructure_test/images/screen_terra3.png)

![Screen GCP 3](https://raw.githubusercontent.com/SofianeHadjadj/interview-test-devops/master/03_infrastructure_test/images/screen_terra4.png)

![Screen GCP 4](https://raw.githubusercontent.com/SofianeHadjadj/interview-test-devops/master/03_infrastructure_test/images/screen_terra5.png)

![Screen GCP 5](https://raw.githubusercontent.com/SofianeHadjadj/interview-test-devops/master/03_infrastructure_test/images/screen_terra6.png)

![Screen GCP 6](https://raw.githubusercontent.com/SofianeHadjadj/interview-test-devops/master/03_infrastructure_test/images/screen_terra7.png)