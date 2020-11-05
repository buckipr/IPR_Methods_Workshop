classdef Person<matlab.mixin.SetGet
    properties 
        x = rand                    % X position
        y = rand                    % Y Position
        infected = false            % Is the person infected?
        recovered = false           % Is the person recovered?
        dead = false                % Is the person dead?
        rr = 0.95;                  % Recovery rate (time constant)
        
        psi = 0
        not_recovered = 1           % Recovery status
        speed = 0.1
    end
    methods 
        function obj = Person(x,y,speed)
            obj.x = x;
            obj.y = y;
            obj.infected = false;
            obj.speed = speed;
            obj.psi = rand*2*pi;
        end
        
        % Update persons XY location in the room. Updatet infection, death
        % and recovery status. 
        function obj = move(obj)
            if obj.dead
                return;
            end
            next = RotMat(obj.psi)*[obj.speed;0]*rand*2+[obj.x;obj.y];
            
            if ~inpolygon(next(1),next(2),50*[-1 1 1 -1]',50*[-1 -1 1 1]')
                obj.psi = obj.psi+pi;
                next = RotMat(obj.psi)*[obj.speed;0]*rand+[obj.x;obj.y];
            end
            
            if obj.infected
                obj.not_recovered = obj.not_recovered*obj.rr +randn*0.05;
                if obj.not_recovered<0.1
                    obj.recovered = true;
                    obj.infected = false;
                end
                if rand<0.01
                    obj.dead = true;
                    obj.infected = false;
                end
            end
            
                        
            
            obj.x = next(1);
            obj.y = next(2);
            obj.psi = obj.psi+(rand-0.3);
        end
         
        function d = dist(obj1,obj2)
           d = norm([obj1.x-obj2.x;obj1.y-obj2.y]); 
        end
        
        function scatter(obj,h)
%             hold(h,'off')
            if  obj.infected
                scatter(h,obj.x,obj.y,'r');
            elseif ~obj.infected
                scatter(h,obj.x,obj.y,'b');
            end
%             drawnow();
        end
    end
    
    
end

function Omega = RotMat(psi)
Omega = [sin(psi) -cos(psi); cos(psi) sin(psi)];
end