# Automation

For this exercise, I am using my favorite automation tool, Jenkins.
To be able to launch my `Jenkinsfile` it is enough to:

![Launch procedure](https://raw.githubusercontent.com/SofianeHadjadj/interview-test-devops/master/01_automation_test/images/screen_jenk3.png)

- Create a `Pipeline` project
- Choose the option `Pipeline script from SCM`
- Select the `Git` option for the SCM field
- Indicate the url of my project
- Indicate the path of my Jenkinsfile: `01_automation_test / Jenkinsfile`
- Save
- Launch the build from the Jenkins interface

**Make sure that port 80 is not already in use, if so, consider changing it**

### Result

![Result](https://raw.githubusercontent.com/SofianeHadjadj/interview-test-devops/master/01_automation_test/images/screen_jenk1.png)

![Result 2](https://raw.githubusercontent.com/SofianeHadjadj/interview-test-devops/master/01_automation_test/images/screen_jenk2.png)