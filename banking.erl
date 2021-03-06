% @Author: Zeeshan  Ahmad
% @Date:   2020-10-08 14:48:12
% @Last Modified by:   Zeeshan  Ahmad
% @Last Modified time: 2020-10-19 11:21:00

-module(banking).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,terminate/2, code_change/3]).
%% Server API
-export([start_link/0, stop/0]).
%% clint API
-export([createAccount/1,depositBalance/2,withdrawBalance/2]).


start_link() ->
    gen_server:start_link({local,?MODULE},?MODULE,[],[]). 

stop() ->
    gen_server:cast(?MODULE,stop).       


createAccount(Who)-> 
	gen_server:call(?MODULE, {new, Who}).
 depositBalance(Who, Amount)  -> 
	gen_server:call(?MODULE, {add, Who, Amount}).
withdrawBalance(Who, Amount) -> 
	gen_server:call(?MODULE, {remove, Who, Amount}).

init([]) -> 
	{ok, ets:new(?MODULE,[])}.



handle_call({new,Who}, _From, Tab) ->
	Reply = case ets:lookup(Tab, Who) of
% the empty [] BRACKET MEANS IF THE NAME THAT WE ARE PASSING I NOT IN LIST THEN CREATE NEW ACCOUNT  
		[]  -> ets:insert(Tab, {Who,0}),  
			   io:format("Welcome ~p Your Account has been created",[Who]);
% the empty [_] BRACKET MEANS IF THE NAME THAT WE ARE PASSING IS IN LIST THEN CREATE NEW ACCOUNT  
		[_] -> io:format(" ~p You Are already Our Customer ~n",[Who])
	    end,
	{reply, Reply, Tab};
	
%cRDIT BALANCE
handle_call({add,Who,X}, _From, Tab) ->
    Reply = case ets:lookup(Tab, Who) of
		[]  -> 
			io:format("Sorry you Don't Have account in Our bank ~n"),
		    io:format("Create Account First~n");
    	[{Who,Balance}] ->
		    NewBalance = Balance + X,
		    ets:insert(Tab, {Who, NewBalance}),
		   io:format("~s Your Account is Credited By ~p Rs.~n",[Who,X]),
		   io:format("YOur Total Balance is ~p",[NewBalance])
	    end,
	{reply, Reply, Tab};
	
%withdrawBalance BALANCE FUNCTION
handle_call({remove,Who, X}, _From, Tab) ->
    Reply = case ets:lookup(Tab, Who) of
		[]  -> io:format("Sorry ! you are not our customer~n");
		[{Who,Balance}] when X =< Balance ->
		    NewBalance = Balance - X,
			ets:insert(Tab, {Who, NewBalance}),
			io:format("Thanks ~p  Your Updated balance is ~p ~n",[ Who,NewBalance]);	
		[{Who,Balance}] ->
		io:format("Sorry  ~p  You have only is ~p",[ Who,Balance])
	    end,
	{reply, Reply, Tab};

handle_call(Message, _From, State) ->
io:format("received other handle_call message: ~p~n",[Message]),
		{reply, ok, State}.	

handle_cast(stop,State) ->
io:format("SERVER IS STOPPING"),
	{stop,normal,State};
		
handle_cast(Message, State) ->
io:format("received other handle_cast call : ~p~n",[Message]),
{noreply,State}.

handle_info(_Info, State) -> 
{noreply, State}.

terminate(Reason, _State) ->
io:format("Stopwatch server is shutting down with Reason: ~p~n",[Reason]),
ok.

code_change(_OldVsn, State, _Extra) -> 
	{ok, State}.

    
