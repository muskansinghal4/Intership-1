#Ques1 Area Calculator
def Calculate_area(shape, dimensions):
    if shape.lower() == "rectangle":
        length, width = dimensions
        return length * width
    elif shape.lower() == "circle":
        radius, = dimensions
        return 3.14159 * radius * radius
    else:
        return "Invalid shape"
print(Calculate_area("rectangle", (7, 50))) 
print(Calculate_area("circle", (7,)))      
print(Calculate_area("triangle", (23, 10)))   

#Ques2 String Manipulation
def reverse_words(text):
  word = text.split()
  word.reverse()
  return " ".join(word)
print(reverse_words("Hi there"))
print(reverse_words("How are you"))

#Ques3 List Statistics
def analyze_list(numbers):
    dictn={}
    dictn["Maximum"]=max(numbers)
    dictn["Minimum"]=min(numbers)
    dictn["Sum"]=sum(numbers)
    dictn["Average"]=sum(numbers)/len(numbers)
    return dictn
numbers=[20,40,60,80,100]
print(analyze_list(numbers))

#Ques4 Filtering with Lambda
def filter_short_names(names, max_length):
    return list(filter(lambda name: len(name) < max_length, names))
product_names = ["Apple","Banana","Orange","Pinapple"]
filtered_names = filter_short_names(product_names, 7)
print(filtered_names) 

#Ques5 Text Analyzer
def analyze_text(text):
    text = text.lower()
    for char in "!@#$%^&*()-=+{};:'<>,.?/~\\|\t\n\r":
        text = text.replace(char, "")

    words = text.split()
    word_count = len(words)
    char_count = sum(len(word) for word in words)

    word_counts = {}
    for word in words:
        word_counts[word] = word_counts.get(word, 0) + 1

    most_frequent_word = max(word_counts, key=word_counts.get)

    return {
        "word_count": word_count,
        "char_count": char_count,
        "most_frequent_word": most_frequent_word
    }

text = "Hi! how are you what are you doing?."
analysis = analyze_text(text)
print(analysis)
