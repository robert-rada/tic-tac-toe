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

    for turn = 1 : 8

        if (mod(turn + player_symbol, 2) == 0)
            board = playerMove(board, player_symbol);
        else
            board = computerMove(board, player_symbol);
        end

        drawBoard(board);

        check = checkBoard(board, player_symbol);
        if (check != 0)
            result = check;
            return;
        end
    end

    close all
end

function drawBoard(board)
    hold off
    plot([0, 0], [0, 3]);
    hold on
    plot([0, 3], [3, 3]);
    plot([0, 3], [0, 0]);
    plot([3, 3], [0, 3]);
    plot([1, 1], [0, 3]);
    plot([2, 2], [0, 3]);
    plot([0, 3], [1, 1]);
    plot([0, 3], [2, 2]);

    for x = 1 : 3
        for y = 1 : 3
            if (board(x, y) == 1)
                drawX(x-1, y-1);
            elseif (board(x, y) == 2)
                drawO(x-1, y-1);
            end
        end
    end
end

function new_board = playerMove(board, player_symbol)
    new_board = board;

    while (1)
        [x, y, buttons] = ginput(1);
        if (buttons == 1)
            i = ceil(x);
            j = ceil(y);
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

function state = checkBoard(board, player_symbol)
    state = 0;

    for x = 1 : 3
        if (board(x, 1) == board(x, 2) && board(x, 2) == board(x, 3))
            if (player_symbol == board(x, 1))
                state = 1;
            else
                state = -1;
            end
            return
        elseif (board(1, x) == board(2, x) && board(2, x) == board(3, x))
            if (player_symbol == board(1, x))
                state = 1;
            else
                state = -1;
            end
            return
        end 
    end

    if (board(1, 1) == board(2, 2) && board(2, 2) == board(3, 3) ||
        board(3, 1) == board(2, 2) && board(2, 2) == board(1, 3))

        if (player_symbol == board(2, 2))
            state = 1;
        else
            state = -1;
        end
    end
            
end

function drawX(x, y)
    plot([x+0.25 x+0.75], [y+0.25 y+0.75]);
    plot([x+0.25 x+0.75], [y+0.75 y+0.25]);
end

function drawO(x, y)
    radius = 0.4;
    t = linspace(0,2*pi,100)'; 
    cx = radius .* cos(t) + x + 0.5; 
    cy = radius .* sin(t) + y + 0.5; 
    plot(cx,cy); 
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

