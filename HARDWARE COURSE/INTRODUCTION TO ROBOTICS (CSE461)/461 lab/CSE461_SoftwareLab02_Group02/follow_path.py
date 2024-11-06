#!/usr/bin/python3
import rospy
from geometry_msgs.msg import Twist
def move():
    # Starts a new node
    rospy.init_node('follow_path', anonymous=True)
    velocity_publisher = rospy.Publisher('/husky_velocity_controller/cmd_vel',
    Twist, queue_size=10)
    vel_msg = Twist()
    # Receiveing the user's input
    print("Let's move your robot")
    speed = input("Input your speed:")
    distance = input("Type your distance:")
    isForward = input("Foward?: ") # True or False
    speed = float(speed)
    distance = float(distance)
    isForward = int(isForward)
    
    # Checking if the movement is forward or backward
    if(isForward):
        vel_msg.linear.x = abs(speed)
    else:
        vel_msg.linear.x = -abs(speed)

    # Since we are moving just in the x-axis
    vel_msg.linear.y = 0
    vel_msg.linear.z = 0
    vel_msg.angular.x = 0
    vel_msg.angular.y = 0
    vel_msg.angular.z = 0
    
    while not rospy.is_shutdown():
        # Setting the current time for distance calculation
        t0 = rospy.Time.now().to_sec()
        current_distance = 0
        # Loop to move the turtle in a specified distance
        while(current_distance < distance):
            # Publish the velocity
            velocity_publisher.publish(vel_msg)
            # Takes actual time for distance calculation
            t1 = rospy.Time.now().to_sec()
            # Calculates distancePoseStamped
            current_distance = speed*(t1-t0)

        # After the loop, stop the robot
        vel_msg.linear.x = 0
        # Force the robot to stop
        velocity_publisher.publish(vel_msg)

if __name__ == '__main__':
    try: move()
    except rospy.ROSInterruptException: pass