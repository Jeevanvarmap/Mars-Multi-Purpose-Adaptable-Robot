# -*- coding: utf-8 -*-
from flask import Flask, render_template, Response
import time
import serial
import cv2

app = Flask(__name__)
vid = cv2.VideoCapture(0)
vid.release

@app.route('/')
def index():
    return "Multipurpose Adaptable Robot (Mars)" #you can customze index.html here

def generate_frames():
    while True:
        ret, frame = vid.read()
        if not ret:
            break;
        else:
            ret, buffer = cv2.imencode('.jpeg',frame)
            frame = buffer.tobytes()
            yield (b' --frame\r\n' b'Content-type: imgae/jpeg\r\n\r\n' + frame +b'\r\n')
    
@app.route('/camera')
def camera():
    return render_template('camera.html')

@app.route('/video_feed')
def video_feed():
    return Response(generate_frames(),mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/move/<string:direction>')
def move(direction):
    if(direction=="f"):
        ser.write(b"mf\n")
        return "Robot Moving forward"
    elif(direction=="b"):
    	ser.write(b"mb\n")
        return "Robot Moving backward"
    elif(direction=="l"):
    	ser.write(b"ml\n")
        return "Robot Moving left"
    elif(direction=="r"):
    	ser.write(b"mr\n")
        return "Robot Moving right"
    elif(direction=="s"):
        ser.write(b"ms\n")
        return "Robot Stopped"

if __name__ == "__main__":
   ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
   ser.reset_input_buffer()
   app.run(host='0.0.0.0', port=5000, debug=True)


