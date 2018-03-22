QT += quick
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += \
    Src/Main.cpp

RESOURCES += \
    Qml.qrc \
    Img.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

DESTDIR = $$_PRO_FILE_PWD_/bin
UI_DIR = $$_PRO_FILE_PWD_/build
MOC_DIR = $$_PRO_FILE_PWD_/build
RCC_DIR = $$_PRO_FILE_PWD_/build
OBJECTS_DIR = $$_PRO_FILE_PWD_/build

CONFIG(debug, debug|release) {
} else {
    QMAKE_POST_LINK += $(STRIP) $(TARGET)
}
