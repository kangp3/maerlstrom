%%%%% Naive version
-module(echo_server).

-export([start_link/0, echo/2]).

%%% Client API
start_link() -> spawn_link(fun loop/0).

%% Synchronous call
echo(Pid, Data) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, {echo, Data}},
    receive
        {Ref, ReturnData} ->
            erlang:demonitor(Ref, [flush]),
            ReturnData;
        {'DOWN', Ref, process, Pid, Reason} ->
            erlang:error(Reason)
    after 5000 ->
        erlang:error(timeout)
    end.

%%% Server functions
loop() ->
    receive
        {Pid, Ref, {echo, Data}} ->
            % send data back to pid
            Pid ! {Ref, lists:concat(["ECHOING: ", Data])},
            loop();

        {Pid, Ref, terminate} ->
            Pid ! {Ref, ok},
            terminate();
        Unknown ->
            %% do some logging here too
            io:format("Unknown message: ~p~n", [Unknown]),
            loop()
    end.

%%% Private functions
terminate() ->
    [io:format("process was set free.~n")],
    ok.
