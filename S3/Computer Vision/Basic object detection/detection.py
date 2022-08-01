import streamlit as st
import numpy as np
import cv2


profiles = {
    "Apple": {
        "lower": 0,
        "upper": 10
    },
      "Apple1": {
        "lower": 0,
        "upper": 10
    },
    "Orange": {
        "lower": 30,
        "upper": 45
    }
}


uploaded_file = st.sidebar.file_uploader("Upload an image:")

if uploaded_file is not None:
    #convert string data to numpy array
    npimg = np.frombuffer(uploaded_file.getvalue(), np.uint8)
    # convert numpy array to image
    frame = cv2.imdecode(npimg, cv2.IMREAD_COLOR)

    # Switch to HSV
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)


    lower_h, upper_h = st.slider("Select lower and upper hue:", 0, 360, (0,360))
    mask = cv2.inRange(hsv, (lower_h,100,100), (upper_h,255,255))
    contours, hierarchy = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    cv2.drawContours(frame, contours, -1, (lower_h,100,100), 3)

            
    if contours:
            # for contour in contours:

            # keep the bigest bounding box
            contour = sorted(contours, key=cv2.contourArea, reverse=True)[0]

            # Create the rectangle
            rect = cv2.boundingRect(contour)
            x,y,w,h = rect

            # Draw rectangle on original image
            cv2.rectangle(frame, (x,y), (x+w,y+h), (0,255,255), 2)

            # Add a label to the box
            cv2.putText(frame, "Orange", (x,y), cv2.FONT_HERSHEY_SIMPLEX, 1, (0,0,255), 2)
            
            
            
    for object_name in profiles.keys():
        # Create the mask specific to that object
        lower_h = profiles[object_name]["lower"]
        upper_h = profiles[object_name]["upper"]
        mask = cv2.inRange(hsv, (lower_h,100,100), (upper_h,255,255))

        # Find the object based on the mask.
        contours, hierarchy = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)

        if contours:
            # for contour in contours:

            # keep the bigest bounding box
            contour = sorted(contours, key=cv2.contourArea, reverse=True)[0]

            # Create the rectangle
            rect = cv2.boundingRect(contour)
            x,y,w,h = rect

            # Draw rectangle on original image
            cv2.rectangle(frame, (x,y), (x+w,y+h), (0,255,255), 2)

            # Add a label to the box
            cv2.putText(frame, object_name, (x,y), cv2.FONT_HERSHEY_SIMPLEX, 1, (0,0,255), 2)


    
    # # Convert from RGB to BGR
    frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    st.image(uploaded_file.getvalue())
    st.image(frame)

    