% @Author: Zeeshan  Ahmad
% @Date:   2020-09-18 18:18:53
% @Last Modified by:   Zeeshan  Ahmad
% @Last Modified time: 2020-09-18 18:18:54
%Caalculate The minimum from list
-module(list_min_max).
-export([smallest/1, largest/1]).

smallest([]) ->
 io:fwrite("empty list~n");

smallest([H|T])  ->
        smallest(H,T).

smallest(Min, [H|T]) ->
        case Min < H of
                true ->  smallest(Min, T);
                false -> smallest(H, T)
        end;

smallest(Min, []) -> 
    io:fwrite("Smallest=~p~n",[Min]).

%-------------------------------------------------------------------
largest([])     -> 
    io:fwrite("empty list~n");
largest([H|T])  ->
                largest(H, T).

largest(Max, [H|T])->
 case Max > H of
    true    -> largest(Max, T);
    false   -> largest(H, T)
 end;

largest(Max, [])        
-> io:fwrite("Largest=~p~n",[Max]).