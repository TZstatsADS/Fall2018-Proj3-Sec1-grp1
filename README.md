# Project: Can you unscramble a blurry image? 
![image](figs/example.png)

### [Full Project Description](doc/project3_desc.md)

Term: Fall 2018

+ Team 1
+ Team members
	+ Han, Liu lh2862@columbia.edu
	+ Ji, Hongyu hj2475@columbia.edu
	+ Lin, Yi yl3901@columbia.edu
	+ Wang, Zehan zw2457@columbia.edu
	+ Wei, Xiaojie xw2536@columbia.edu

+ Project summary: In this project, we created a classification engine for enhance the resolution of images. 
	+ Our client is interested in creating an mobile AI program that can enhance the resolution of blurry and low-resolution images. Our goal is to enlarge the low resolution image 2 times, and produce a predicted high resolution image as output based on the low-resolution input. 
	+ We use patch-based method to extract features. The baseline model here is Gradient Boosting Machines, and we use XgBoost as our improved model with depth equal to 7 and nrounds equal to 10. The time cost of the improved model to predict 1500 HR images is around 16 mins. The error(MSE) is 0.00257. The PSNR is 25.893.

**Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
