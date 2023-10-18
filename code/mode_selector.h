/*
 * Copyright (C)  2019~2020  偕臧  All rights reserved.
 *
 * Author:  xmuli(偕臧) xmulitech@gmail.com
 *
 * GitHub:  https://github.com/XMuli
 * Blogs:   https://ifmet.cn
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
#ifndef MODE_SELECTOR_H
#define MODE_SELECTOR_H

#include <QWidget>
#include "ChessBoard.h"
#include "MachineGame.h"
#include "NetworkGame.h"
#include "ChessBoard.h"

class ModelSelector : public QDialog
{
    Q_OBJECT
public:
    explicit ModelSelector(QWidget *parent = nullptr);
    ~ModelSelector();

private:
    QPushButton* m_buttons[3];
    ChessBoard* m_pAgainstYourself;
    MachineGame* m_pMachineGame;
    NetworkGame* m_pNetworkGame;
};

#endif // MODE_SELECTOR_H
