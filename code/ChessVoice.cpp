/*
 * Author:  kirayamato
 * mail:    kirawhile1@gmail.com
 * github:  https://github.com/kira-yamatoo
 * blogs:   http://www.kirayamato.fun/
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/gpl-3.0.html>.
 */
#include "ChessVoice.h"

#include <QDebug>

ChessVoice::ChessVoice(QObject *parent) : QObject(parent) {
  // 初始化声音播放器
  sound_effect_.setVolume(0.9f);
}
ChessVoice::~ChessVoice() { qDebug() << __FUNCTION__; }

void ChessVoice::voiceWin() {
  sound_effect_.setSource(QUrl::fromLocalFile(":/sound/WinSound.wav"));
  //  sound_effect_.setLoopCount(-1); // 设置循环播放
  sound_effect_.play();
  qDebug() << __FUNCTION__;
}

void ChessVoice::voiceSelect() {
  sound_effect_.setSource(QUrl::fromLocalFile(":/sound/selectChess.wav"));
  sound_effect_.play();
  qDebug() << __FUNCTION__;
}

void ChessVoice::voiceMove() {
  sound_effect_.setSource(QUrl::fromLocalFile(":/sound/moveChess.wav"));
  sound_effect_.play();
  qDebug() << __FUNCTION__;
}

void ChessVoice::voiceEat() {
  sound_effect_.setSource(QUrl::fromLocalFile(":/sound/eatChess.wav"));
  sound_effect_.play();
  qDebug() << __FUNCTION__;
}

void ChessVoice::voiceBack() {
  sound_effect_.setSource(QUrl::fromLocalFile(":/sound/backChess.wav"));
  sound_effect_.play();
  qDebug() << __FUNCTION__;
}

void ChessVoice::voiceGeneral() {
  sound_effect_.setSource(QUrl::fromLocalFile(":/sound/generalSound.wav"));
  sound_effect_.play();
  qDebug() << __FUNCTION__;
}
