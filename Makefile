CC = clang
FRAMEWORK_PATH = -F /System/Library/PrivateFrameworks
FRAMEWORKS = -framework login
TARGET = lockscreen
SRC = lockscreen.c

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(FRAMEWORK_PATH) $(FRAMEWORKS) $(SRC) -o $(TARGET)

clean:
	rm -f $(TARGET)
