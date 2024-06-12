-module(maerlstrom_stdin_slurper).
-behavior(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    spawn_link(fun() -> start_loop() end),
    {ok, []}.

start_loop() ->
    loop().

loop() ->
    case io:get_line("") of
        eof ->
            loop();
        Data ->
            io:format("GOT LINE: ~s", [Data]),
            loop()
    end.

handle_call(hello, _From, _State) ->
    io:format("Hello~n"),
    {reply, ok, []}.
