-module(irc_test).

-behavior(gen_server).

-export([init/1, code_change/3, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

-export([start/0, stop/1]).

-record(state, {socket}).

start() ->
  lager:info("Starting IRC test"),
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop(Pid) -> 
  lager:info("Stopping IRC test"),
	gen_server:call(Pid, stop).


init([]) ->
  lager:info("Init IRC test"),
  {ok, Socket} = gen_tcp:connect("irc.freenode.net", 6667, [binary, {active,true}]),
  gen_tcp:send(Socket, "NICK artgon_1\r\n"),
  gen_tcp:send(Socket, "USER artgon_1 8 * : Arty G\r\n"),
  {ok, #state{socket=Socket}}.

code_change(_OldVersion, State, _Extra) -> {ok, State}.

handle_call(stop, _Caller, State) -> 
  lager:info("Call IRC test"),
  gen_tcp:send(State#state.socket, "QUIT :ADIOS\r\n"),
  {stop, normal, ok, State};

handle_call(Req, _Caller, State) -> 
  lager:info("Call IRC test"),
  {reply, sweet, State}.

handle_cast(Req, State) ->
  lager:info("Cast IRC test"),
  {noreply, State}.

handle_info({tcp, _, Stuff}, State) ->
  lager:info("~p", [Stuff]),
  {noreply, State};

handle_info(Req, State) -> 
  lager:info("Info IRC test"),
  lager:info("Unkown message: ~w~n", [Req]),
  {noreply, State}.

terminate(Reason, State) -> 
  lager:info("Terminate IRC test"),
  ok.


  
