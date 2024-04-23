def search_objects(obj,key):
    keys = key.split("/")
    current_obj = obj
    for i in keys:
        if isinstance(current_obj,dict) and i in current_obj:
            current_obj = current_obj[i]
        else:
            return None
    return current_obj

object1={"a":{"b":{"c":"d"}}}
key1="a/b/c"
print(f"value1 = {search_objects(object1,key1)}")

object2={"x":{"y":{"z":"a"}}}
key2="x/y/z"
print(f"value2 = {search_objects(object2,key2)}")