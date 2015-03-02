function rrt
    arm_tree = [10,10,NaN,NaN;NaN,NaN,NaN,NaN];
    obstacle = [];
    clf;
    title('RRT for a Two-Link Robot Arm');
    xlabel('Joint 1 Angle');
    ylabel('Joint 2 Angle');
    hold all;
    
    while true
        state = random_state;
        near_column = near(state(1), state(2), arm_tree);
        if isnan(near_column), continue; end
        near_y = arm_tree(1,(near_column+1));
        loc1 = joint_tip(state(1));
        loc2 = joint_tip(state(2), loc1(1), loc1(2));
        move_1 = true;
        
        if obstacle_check(loc1(1), loc1(2), loc2(1), loc2(2))
            obstacle = vertcat(obstacle, [state(1), state(2)]);
            continue;
        end
        
        while true
            next_2 = increment(2, near_y, state(2));
            loc1 = joint_tip(arm_tree(1,near_column));
            loc2 = joint_tip(arm_tree(1,near_column) + next_2, loc1(1), loc1(2));
            if obstacle_check(loc1(1), loc1(2), loc2(1), loc2(2))
                move_1 = false;
                break;
            else
                if isnan(next_2), break; end;
                near_y = next_2;
            end
            if next_2 == state(2)
                vertex_find = tree_find(arm_tree(1,near_column), next_2, arm_tree);
                if isnan(vertex_find)
                    arm_tree = add(arm_tree(1, near_column), next_2, near_column, arm_tree);
                    near_column = size(arm_tree, 1) - 2;
                else
                    near_column = vertex_find;
                end
                break; 
            end
        end
        
        if move_1
            if mod(near_column,2) ~= 1, near_column = near_column - 1; end
            near_x = arm_tree(1, near_column);
            if near_x > 180
                break;
            end
            while true
                next_1 = increment(1, near_x, state(1));
                loc1 = joint_tip(next_1);
                loc2 = joint_tip(next_1 + state(2), loc1(1), loc1(2));
                if obstacle_check(loc1(1), loc1(2), loc2(1), loc2(2))
                    break;
                else
                    if isnan(next_1), break; end;
                    near_x = next_1;
                end
                if next_1 == state(1)
                    vertex_find = tree_find(next_1, state(2), arm_tree);
                    if isnan(vertex_find)
                        arm_tree = add(state(1), state(2), near_column, arm_tree);
                    end
                    break;
                end
            end
        else
            continue;
        end
        if ~isnan(tree_find(135, 0, arm_tree)), break; end
    end
    
    for r = 1:size(obstacle,1)
        plot(obstacle(r,1), obstacle(r,2), 'x', 'Color', 'r', 'MarkerSize', 10);
        hold all;
    end
end

function state = random_state
    if unidrnd(10) == 1
        state(1) = 135;
        state(2) = 0;
    else
        x = unidrnd(185) - 1;
        y = unidrnd(360) - 1;
        state(1) = x - mod(x,5); %increments of 5
        state(2) = y - mod(y,10); %increments of 10
    end
end

function vertex_column = near(x, y, tree_matrix)
    near_value = Inf;
    column = 1;
    while true
        if isnan(tree_matrix(1,column))
            column = column - 2;
            break; 
        end
        distance = dist(x,y,tree_matrix(1,column),tree_matrix(1,(column+1)));
        if distance == 0
            column = NaN; %duplicate
            break;
        elseif distance < near_value
            near_value = distance;
        end
        column = column + 2;
    end
    vertex_column = column;
end

function vertex_column = tree_find(x, y, tree_matrix)
    column = 1;
    while true
        if isnan(tree_matrix(1,column))
            column = NaN;
            break;
        elseif (tree_matrix(1,column) == x) && (tree_matrix(1,(column+1)) == y)
            break;
        end
        column = column + 2;
    end
    vertex_column = column;
end

function matrix = add(x, y, column, tree_matrix)
    for r = 2:size(tree_matrix,1)
        if r ~= size(tree_matrix,1)
            if isnan(tree_matrix(r,column))
                tree_matrix(r,column) = x;
                tree_matrix(r,(column+1)) = y;
                break;
            end
        else
            tree_matrix(r,column) = x;
            tree_matrix(r,(column+1)) = y;
            tree_matrix = vertcat(tree_matrix,(ones(1,size(tree_matrix,2))*NaN));
            break;
        end
    end
    tree_matrix(1,(size(tree_matrix,2)-1)) = x;
    tree_matrix(1,size(tree_matrix,2)) = y;
    matrix = horzcat(tree_matrix,(ones(size(tree_matrix,1),2)*NaN));
    
    
    plot([tree_matrix(1,column),x], [tree_matrix(1,(column+1)),y]);
    hold all;
end

function boolean = obstacle_check(x1, y1, x2, y2)
    x3 = 0;
    y3 = 2;
    if x1 < 0
        x4 = 0;
        y4 = 4;
        if ((det([1,1,1;x1,x2,x3;y1,y2,y3])*det([1,1,1;x1,x2,x4;y1,y2,y4]) <= 0) && (det([1,1,1;x1,x3,x4;y1,y3,y4])*det([1,1,1;x2,x3,x4;y2,y3,y4]) <= 0))
            boolean = true;
        else
            x4 = 2;
            y4 = 2;
            if ((det([1,1,1;x1,x2,x3;y1,y2,y3])*det([1,1,1;x1,x2,x4;y1,y2,y4]) <= 0) && (det([1,1,1;x1,x3,x4;y1,y3,y4])*det([1,1,1;x2,x3,x4;y2,y3,y4]) <= 0))
                boolean = true;
            else
                boolean = false;
            end
        end
    else
        x4 = 2;
        y4 = 2;
        if ((det([1,1,1;x1,x2,x3;y1,y2,y3])*det([1,1,1;x1,x2,x4;y1,y2,y4]) <= 0) && (det([1,1,1;x1,x3,x4;y1,y3,y4])*det([1,1,1;x2,x3,x4;y2,y3,y4]) <= 0))
            boolean = true;
        else
            boolean = false;
        end
    end
end

function next = increment(joint, current, goal)
    if current == goal
        next = NaN;
    else
        if joint == 1
            if current < goal
                n = current + 5;
            else
                n = current - 5;
            end
        else
            if current < goal
                up = abs(goal - current);
                down = abs((-1*(360-goal)) - current);
                if up < down
                    n = current + 10;
                    if n >= 360, n = n - 360; end
                else
                    n = current - 10;
                    if n < 0, n = 360 + n; end
                end
            else
                up = abs(current - goal);
                down = abs((-1*(360-current)) - goal);
                if down <= up
                    n = current + 10;
                    if n >= 360, n = n - 360; end
                else
                    n = current - 10;
                    if n < 0, n = 360 + n; end
                end
            end
        end
        next = n;
    end
end

function location = joint_tip(angle, origin_x, origin_y)
    if nargin < 3, origin_y = 0; end
    if nargin < 2, origin_x = 0; end
    location(1) = origin_x + 1.5 * cos(angle * (pi/180)); %x
    location(2) = origin_y + 1.5 * sin(angle * (pi/180)); %y
end

function distance = dist(x1, y1, x2, y2)
    distance = (((x1-x2)^2)+((y1-y2)^2))^.5;
end
