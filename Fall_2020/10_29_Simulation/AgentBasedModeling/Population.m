classdef Population<matlab.mixin.SetGet
    properties
        size                         % Population size
        infected                     % List of infected people
        recovered = false            % List of recovered people
        dead = true                  % List of dead people   
        
        People = Person(0,0,1);
        xy
    end
    
    methods
        function obj = Population(s)
            xy = zeros(2,s);
            infected = false(1,s);
            for ii = 1:s
                xy(1,ii) = (rand-0.5)*100;
                xy(2,ii) = (rand-0.5)*100;
                obj.People(ii) = Person(xy(1,ii),xy(2,ii),1);
            end
            obj.size = s;
            obj.xy = xy;
            obj.infected = infected;
            obj.dead = false(1,s);
            obj.recovered = false(1,s);
        end
        
        function collectxy(obj)
            for ii = 1 : obj.size
                obj.xy(1,ii) = obj.People(ii).x;
                obj.xy(2,ii) = obj.People(ii).y;
                obj.dead(ii) = obj.People(ii).dead;
                obj.recovered(ii) = obj.People(ii).recovered;
                obj.infected(ii) = obj.People(ii).infected;
            end
        end
        
        
        function scatter(obj,h)
            scatter(h,obj.xy(1,obj.infected),obj.xy(2,obj.infected),'r');
            hold(h,'on');
            scatter(h,obj.xy(1,~obj.infected),obj.xy(2,~obj.infected),'b');
            if any(obj.recovered)
                scatter(h,obj.xy(1,obj.recovered),obj.xy(2,obj.recovered),'g');
            end
            if any(obj.dead)
                scatter(h,obj.xy(1,obj.dead),obj.xy(2,obj.dead),'k');
            end
        end
        
        
        % Spread of infection
        function infect(obj,dist,prob)
            d = rangesearch(obj.xy',obj.xy',dist);
            for ii = 1 : obj.size
                if obj.People(ii).dead || obj.People(ii).recovered
                    continue
                end
                N = length(d{ii});
                for jj = 1:N
                    if obj.People(d{ii}(jj)).infected 
                        if rand<prob
                            obj.People(ii).infected = true;
                            obj.infected(ii) = true;
                        end
                        
                    end
                end
            end
        end
        
        
    end
end