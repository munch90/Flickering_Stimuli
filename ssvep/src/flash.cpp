#include "ros/ros.h"
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>


unsigned int xRes = 1800;
unsigned int yRes = 900;
unsigned int screenType = 1; // 0 = full, 1 = chess, 2 = horisontal_line,

unsigned int xSegTotal = 0;
unsigned int ySegTotal = 0;
unsigned int sizeX = 4;
unsigned int sizeY = 4;

unsigned int frequence1 = 3;
unsigned int frequence2 = 5 ;
unsigned int frequence3 = 6 ;
unsigned int frequence4 = 10 ;

unsigned int xSegStart = 0;
unsigned int ySegStart = 0;
unsigned int yRep = 12;
unsigned int xRep = 6;

struct screenSeg {
unsigned int xStartPixel;
unsigned int xStopPixel;

unsigned int yStartPixel;
unsigned int yStopPixel;

    double time;
    double lastTime;
    bool state;

    void screenSegSet(unsigned int xSeg, unsigned int nxSeg, unsigned int ySeg, unsigned int nySeg, unsigned int Hz){
        --xSeg;
        --ySeg;

        xStartPixel = xRes * (xSeg * 1.0/ xSegTotal);
        xStopPixel = xStartPixel + (xRes * (1 * 1.0/ xSegTotal));
        //xStopPixel = nxSeg * xRes * ((xSeg + 1.0) / xSegTotal);

        yStartPixel = yRes * (ySeg * 1.0 / ySegTotal);
        yStopPixel = nySeg * yRes * ((ySeg + 1.0) / ySegTotal);

        time = 1.0 / (Hz * 2);

        state = false;

        lastTime = ros::Time::now().toSec();
    }
};



void changeState(cv::Mat &in, screenSeg &seg);
void changeStateX(cv::Mat &in, screenSeg &seg);


int main(int argc, char **argv) {
    ros::init(argc, argv, "flash");

    ros::NodeHandle n;

    cv::Mat screen = cv::Mat(yRes, xRes, CV_8UC1);

    screenSeg screenS[8][xRep][yRep];  

if (screenType == 0) {

    xSegTotal = 3;
    ySegTotal = 3;

    screenS[0][0][0].screenSegSet(1,1,1,1,frequence1);
    screenS[1][0][0].screenSegSet(3,1,1,1,frequence2);
    screenS[2][0][0].screenSegSet(1,1,3,1,frequence3);
    screenS[3][0][0].screenSegSet(3,1,3,1,frequence4);
}

else if (screenType == 1) {

    xSegTotal = 36;
    ySegTotal = 36;
    xSegStart = xSegTotal-(xSegTotal/3);
    ySegStart = ySegTotal-(ySegTotal/3)-1;


for(size_t j = 2; j < yRep; j++) {
    for (size_t i = 1; i < xRep; i++) {
        if (j % 2 == 0) {
            screenS[0][i][j].screenSegSet(i*2+1,1,j+1,1,frequence1);
            screenS[1][i][j].screenSegSet(i*2,1,j+1,1,frequence1);

            screenS[2][i][j].screenSegSet(i*2+1,1,j+ySegStart,1,frequence2);
            screenS[3][i][j].screenSegSet(i*2,1,j+ySegStart,1,frequence2);

            screenS[4][i][j].screenSegSet(xSegStart+i*2+1,1,j+1,1,frequence3);
            screenS[5][i][j].screenSegSet(xSegStart+i*2,1,j+1,1,frequence3);

            screenS[6][i][j].screenSegSet(xSegStart+i*2+1,1,j+ySegStart,1,frequence4);
            screenS[7][i][j].screenSegSet(xSegStart+i*2,1,j+ySegStart,1,frequence4);
        }
        else {
            screenS[0][i][j].screenSegSet(i*2,1,j+1,1,frequence1);
            screenS[1][i][j].screenSegSet(i*2+1,1,j+1,1,frequence1);

            screenS[2][i][j].screenSegSet(i*2,1,j+ySegStart,1,frequence2);
            screenS[3][i][j].screenSegSet(i*2+1,1,j+ySegStart,1,frequence2);
            
            screenS[4][i][j].screenSegSet(xSegStart+i*2,1,j+1,1,frequence3);
            screenS[5][i][j].screenSegSet(xSegStart+i*2+1,1,j+1,1,frequence3);

            screenS[6][i][j].screenSegSet(xSegStart+i*2,1,j+ySegStart,1,frequence4);
            screenS[7][i][j].screenSegSet(xSegStart+i*2+1,1,j+ySegStart,1,frequence4);
        }
    }
}
}

else if (screenType == 2) {

    xSegTotal = 18;
    ySegTotal = 18;

for(size_t j = 0; j < sizeY*2-1; j++) {
    for (size_t i = 0; i < sizeX; i++) {
        if (j % 2 == 0) {
            screenS[0][i][j].screenSegSet(i*2+1,1,j+1,1,frequence1);
            screenS[1][i][j].screenSegSet(i*2,1,j+1,1,frequence1);

            screenS[2][i][j].screenSegSet(i*2+1,1,j+12,1,frequence2);
            screenS[3][i][j].screenSegSet(i*2,1,j+12,1,frequence2);

            screenS[4][i][j].screenSegSet(11+i*2+1,1,j+1,1,frequence3);
            screenS[5][i][j].screenSegSet(11+i*2,1,j+1,1,frequence3);

            screenS[6][i][j].screenSegSet(11+i*2+1,1,j+12,1,frequence4);
            screenS[7][i][j].screenSegSet(11+i*2,1,j+12,1,frequence4);

        }
        else {
            screenS[0][i][j].screenSegSet(i*2+1,1,j+1,1,frequence1);
            screenS[1][i][j].screenSegSet(i*2,1,j+1,1,frequence1);

            screenS[2][i][j].screenSegSet(i*2+1,1,j+12,1,frequence2);
            screenS[3][i][j].screenSegSet(i*2,1,j+12,1,frequence2);

            screenS[4][i][j].screenSegSet(11+i*2+1,1,j+1,1,frequence3);
            screenS[5][i][j].screenSegSet(11+i*2,1,j+1,1,frequence3);

            screenS[6][i][j].screenSegSet(11+i*2+1,1,j+12,1,frequence4);
            screenS[7][i][j].screenSegSet(11+i*2,1,j+12,1,frequence4);
        }
    }
}
}

else if (screenType == 3) {

    xSegTotal = 18;
    ySegTotal = 18;

for(size_t j = 0; j < sizeY*2-1; j++) {
    for (size_t i = 0; i < sizeX; i++) {
        if (j % 2 == 0) {
            screenS[0][i][j].screenSegSet(i*2+1,1,j+1,1,frequence1);
            screenS[1][i][j].screenSegSet(i*2,1,j+1,1,frequence1);
/*
            screenS[2][i][j].screenSegSet(i*2+1,1,j+12,1,frequence2);
            screenS[3][i][j].screenSegSet(i*2,1,j+12,1,frequence2);

            screenS[4][i][j].screenSegSet(11+i*2+1,1,j+1,1,frequence3);
            screenS[5][i][j].screenSegSet(11+i*2,1,j+1,1,frequence3);

            screenS[6][i][j].screenSegSet(11+i*2+1,1,j+12,1,frequence4);
            screenS[7][i][j].screenSegSet(11+i*2,1,j+12,1,frequence4);*/
        }
        else {
            screenS[0][i][j].screenSegSet(i*2,1,j+1,1,frequence1);
            screenS[1][i][j].screenSegSet(i*2+1,1,j+1,1,frequence1);
/*
            screenS[2][i][j].screenSegSet(i*2,1,j+12,1,frequence2);
            screenS[3][i][j].screenSegSet(i*2+1,1,j+12,1,frequence2);
            
            screenS[4][i][j].screenSegSet(11+i*2,1,j+1,1,frequence3);
            screenS[5][i][j].screenSegSet(11+i*2+1,1,j+1,1,frequence3);

            screenS[6][i][j].screenSegSet(11+i*2,1,j+12,1,frequence4);
            screenS[7][i][j].screenSegSet(11+i*2+1,1,j+12,1,frequence4);*/
        }
    }
}
}

    cv::namedWindow("Thing", CV_WINDOW_NORMAL);
    cv::setWindowProperty("Thing", CV_WND_PROP_FULLSCREEN, CV_WINDOW_FULLSCREEN);
    ros::Rate r(60);

    while(ros::ok()){
 /*   
    const Point* ppt[2] = {pt[0], pt[1]};
    Point pt;
    pt.x = 100;
    pt.y = 100;
    Scalar(0,0,255);
    
    void circle(Mat& "Thing", Point pt, int 10, const Scalar& Scalar, int thickness=1, int lineType=8, int shift=0);
*/
    

    if (screenType == 0) {
        for(size_t j = 0; j < 4; j++) {    
            changeState(screen, screenS[j][0][0]);
        }
    }
    
    else if (screenType == 1 || screenType == 2) {
    for(size_t j = 2; j < yRep; j++) {
        for (size_t i = 1; i < xRep; i++) { 
            changeState(screen, screenS[0][i][j]);  
            changeStateX(screen, screenS[1][i][j]);
            changeState(screen, screenS[2][i][j]);
            changeStateX(screen, screenS[3][i][j]);
            changeState(screen, screenS[4][i][j]);
            changeStateX(screen, screenS[5][i][j]);
            changeState(screen, screenS[6][i][j]);
            changeStateX(screen, screenS[7][i][j]); 
            }    
        }   
    }
    
    else if (screenType == 3) {
    for(size_t j = 0; j < sizeY*2-1; j++) {
        for (size_t i = 0; i < sizeX; i++) { 
            changeState(screen, screenS[0][i][j]);  
            changeStateX(screen, screenS[1][i][j]);
            }
        }
    }  

        cv::imshow("Thing", screen);

        cv::waitKey(1);
        r.sleep();
    }

    return 0;
}


void changeState(cv::Mat &in, screenSeg &seg){
    if(ros::Time::now().toSec() - seg.lastTime < seg.time){
        return;
    }

    seg.lastTime += seg.time;

    for(unsigned int y = seg.yStartPixel; y < seg.yStopPixel; y++){
        for(unsigned int x = seg.xStartPixel; x < seg.xStopPixel; x++){
            in.at<uchar>(y, x) = (seg.state ? 255 : 0);
        }
    }

    seg.state = !seg.state;
}

void changeStateX(cv::Mat &in, screenSeg &seg){
    if(ros::Time::now().toSec() - seg.lastTime < seg.time){
        return;
    }

    seg.lastTime += seg.time;

    for(unsigned int y = seg.yStartPixel; y < seg.yStopPixel; y++){
        for(unsigned int x = seg.xStartPixel; x < seg.xStopPixel; x++){
            in.at<uchar>(y, x) = (seg.state ? 0 : 255);
        }
    }

    seg.state = !seg.state;
}
