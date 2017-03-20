function [] = joc()
    win = 0;
    lose = 0;
    draw = 0;

    running = 1;
    while (running)
        input = startQuery();

        if (input == -1)
            break
        else
            result = startGame(input);
            if (result == -1)
                disp("LOSE");
                lose += 1;
            elseif (result == 0)
                disp("DRAW");
                draw += 1;
            elseif (result == 1)
                disp("WIN");
                win += 1;
            end

            printf("%d wins | %d draws | %d losses\n", win, draw, lose);
            fflush(stdout);
        end
    end

    close all
end

% result:
% -1 = lose
%  1 = win
%  0 = draw

% player_symbol:
% 0 = O
% 1 = X

% board tile:
% 0 = empty
% 1 = X
% 2 = O

function result = startGame(player_symbol)

    board = zeros(3, 3);
    close all
    drawBoard(board);
    result = 0;

    for turn = 1 : 9

        if (mod(turn + player_symbol, 2) == 0)
            board = playerMove(board, player_symbol);
        else
            board = computerMove2(board, turn);
        end

        drawBoard(board);

        check = checkBoard(board, player_symbol);
        if (check != 0)
            result = check;
            return;
        end
    end
end

function drawBoard(board)
    hold off
    plot([0, 0], [0, 3], "linewidth", 5);
    hold on
    plot([0, 3], [3, 3], "linewidth", 5);
    plot([0, 3], [0, 0], "linewidth", 5);
    plot([3, 3], [0, 3], "linewidth", 5);
    plot([1, 1], [0, 3], "linewidth", 5);
    plot([2, 2], [0, 3], "linewidth", 5);
    plot([0, 3], [1, 1], "linewidth", 5);
    plot([0, 3], [2, 2], "linewidth", 5);

    for x = 1 : 3
        for y = 1 : 3
            if (board(x, y) == 1)
                drawX(x-1, y-1);
            elseif (board(x, y) == 2)
                drawO(x-1, y-1);
            end
        end
    end

    drawnow();
end

function new_board = playerMove(board, player_symbol)
    new_board = board;

    while (1)
        [x, y, buttons] = ginput(1);
        if (buttons == 1)
            i = ceil(x);
            j = ceil(y);
            if (i < 1 || i > 3 || j < 1 || j > 3)
                continue;
            end
            if (board(i, j) == 0)
                new_board(i, j) = 2 - player_symbol;
                return;
            end
        end
    end
end

function new_board = computerMove(board, player_symbol)
    new_board = board;

    while (1)
        [x, y, buttons] = ginput(1);
        if (buttons == 1)
            i = ceil(x);
            j = ceil(y);
            if (board(i, j) == 0)
                new_board(i, j) = 2 - (1 - player_symbol);
                return;
            end
        end
    end
end

function [best_x best_y max_win] = bkt1(turn, board)
    player_symbol = mod(turn, 2);
    max_win = -1;
    best_x = 0;
    best_y = 0;

    if (turn == 10)
        max_win = 10;
        return;
    end

    for x = 1 : 3
        for y = 1 : 3
            if (board(x, y) == 0)
                board(x, y) = 2 - player_symbol;

                if (checkBoard(board, player_symbol) != 0)
                    max_win = 1;
                    best_x = x;
                    best_y = y;
                    return;
                end

                win = bkt2(turn+1, board);
                if (win >= max_win)
                    max_win = win;
                    best_x = x;
                    best_y = y;
                end

                board(x, y) = 0;
            end
        end
    end
end

function win = bkt2(turn, board)
    win = 0;
    player_symbol = mod(turn, 2);

    if (turn == 10)
        return;
    end

    nr = 0;

    for x = 1 : 3
        for y = 1 : 3
            if (board(x, y) == 0)
                board(x, y) = 2 - player_symbol;

                if (checkBoard(board, player_symbol) != 0)
                    win = -1;
                    return;
                end

                [a b t] = bkt1(turn + 1, board);
                if (t == -1)
                    win = -1;
                    return;
                end

                nr += 1;
                win += t;
                board(x, y) = 0;
            end
        end
    end

    win /= nr;
end

function new_board = computerMove2(board, turn)
    new_board = board;

    if (turn == 1)
        new_board(1, 1) = 1;
        return
    end
    if (turn == 2)
        if (board(2, 2) == 0)
            new_board(2, 2) = 2;
        else
            new_board(1, 1) = 2;
        end
        return
    end
    if (turn == 3)
        if (board(1, 2) == 2 || board(1, 3) == 2)
            new_board(2, 1) = 1;
        elseif (board(2, 1) == 2 || board(2, 2) == 2 || board(3, 1) == 2)
            new_board(1, 2) = 1;
        elseif (board(2, 3) == 2)
            new_board(2, 2) = 1;
        else
            new_board(1, 3) = 1;
        end
        return
    end

    [x y win] = bkt1(turn, board);
    new_board(x, y) = 2 - mod(turn, 2);
end

function state = checkBoard(board, player_symbol)
    state = 0;

    for x = 1 : 3
        if (board(x, 1) == board(x, 2) && board(x, 2) == board(x, 3) && board(x, 1) != 0)
            if (player_symbol ==  2 - board(x, 1))
                state = 1;
            else
                state = -1;
            end
            return
        elseif (board(1, x) == board(2, x) && board(2, x) == board(3, x) && board(1, x) != 0)
            if (player_symbol ==  2 - board(1, x))
                state = 1;
            else
                state = -1;
            end
            return
        end 
    end

    if (((board(1, 1) == board(2, 2) && board(2, 2) == board(3, 3)) || 
        (board(3, 1) == board(2, 2) && board(2, 2) == board(1, 3))) && board(2, 2) != 0)

        if (player_symbol == 2 - board(2, 2))
            state = 1;
        else
            state = -1;
        end
    end
end

function drawX(x, y)
    plot([x+0.25 x+0.75], [y+0.25 y+0.75], "linewidth", 5);
    plot([x+0.25 x+0.75], [y+0.75 y+0.25], "linewidth", 5);
end

function drawO(x, y)
    radius = 0.3;
    t = linspace(0,2*pi,100)'; 
    cx = radius .* cos(t) + x + 0.5; 
    cy = radius .* sin(t) + y + 0.5; 
    plot(cx,cy, "linewidth", 5); 
end

function input = startQuery()
    disp("\n\n");
    disp("Press x to start with X");
    disp("Press 0 to start with 0");
    disp("Press q to quit");
    fflush(stdout);

    stop = 0;
    while (stop == 0)
        stop = 1;
        input = kbhit();

        if (input == 'x' || input == 'X')
            input = 1;
        elseif (input == '0' || input == 'o' || input == 'O')
            input = 0;
        elseif (input == 'q' || input == 'Q' || input == 27)
            input = -1;
        else
            stop = 0;
        end
    end
end

