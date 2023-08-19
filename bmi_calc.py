height_in_feet=input("enter height in feet: ")
weight_in_kg=input("enter weight in kg: ")
def bmi_calc(x,y):
    height_in_meter=(float(x)*0.12*2.54)
    bmi=float(y)/(height_in_meter*height_in_meter)
    if bmi >= 30:
        print("BMI: "+str(bmi)+ "\nYOU ARE OBESE :( ")
    elif bmi >= 25:
        print("BMI: "+str(bmi)+ "\nYOU ARE OVERWEIGHT :/ ")
    else:
        print("BMI: "+str(bmi)+ "\nYOU ARE HEALTHY :) ")

bmi_calc(height_in_feet,weight_in_kg)
