
QT       += core gui network multimedia

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = ChineseChess
TEMPLATE = app


SOURCES += \
    code/main.cpp\
    code/ChessBoard.cpp \
    code/ChessPieces.cpp \
    code/ChessStep.cpp \
    code/ChessVoice.cpp \
    code/MachineGame.cpp \
    code/NetworkGame.cpp \
    code/AboutAuthor.cpp \
    code/mode_selector.cpp

HEADERS  += \
    code/ChessBoard.h \
    code/ChessPieces.h \
    code/ChessStep.h \
    code/ChessVoice.h \
    code/MachineGame.h \
    code/NetworkGame.h \
    code/AboutAuthor.h \
    code/mode_selector.h

FORMS    += \
    code/ChessBoard.ui \
    code/AboutAuthor.ui

RESOURCES += \
    app.qrc

RC_FILE = res.rc

DESTDIR = $$PWD/build

target.path = $$PWD/local_bin
INSTALLS += target
