
def handler(event, context):
    temp_f = 77
    temp_c = (temp_f - 32) * 5 / 9
    message = f"{temp_f}°F is equal to {temp_c:.2f}°C"

    return {
        "statusCode": 200,
        "body": message
    } 
   
