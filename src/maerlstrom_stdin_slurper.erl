-module(maerlstrom_stdin_slurper).
-behavior(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    io:format("STARTED UP~n"),
    spawn_link(fun() -> loop() end),
    {ok, []}.

loop() ->
    case io:get_line("PROMPT:") of
        eof ->
            io:format("EOF LOOPING~n"),
            loop();
        Data ->
            io:format("GOT LINE: ~s", [Data]),
            loop()
    end.

handle_call(hello, _From, _State) ->
    io:format("Hello~n"),
    {reply, ok, []}.
