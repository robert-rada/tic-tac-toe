function [] = joc()
    win = 0;
    lose = 0;

    running = 1;
    while (running)
        input = startQuery();
        
        if (input == 2)
            break
        end
    end
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
            input = 2;
        else
            stop = 0;
        end
    end
end

