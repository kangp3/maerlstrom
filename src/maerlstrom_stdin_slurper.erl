-module(maerlstrom_stdin_slurper).
-behavior(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init(_Args) ->
    {ok, []}.

handle_call(hello, _From, _State) ->
    io:format("Hello~n"),
    {reply, ok, []}.
