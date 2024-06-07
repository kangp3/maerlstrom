#!/usr/bin/env escript

-export([main/1]).

-define(FUNC(F), fun(I) -> F(I) end). % Can't use fun quote_pids/1 in escript :(

to_erlang_term(Bin) ->
    {ok, Scanned, _} = erl_scan:string(binary_to_list(Bin)),
    {ok, Parsed} = erl_parse:parse_exprs(Scanned),
    {value, Evaled, []} = erl_eval:exprs(Parsed, []),
    Evaled.

remove_trailing_newlines(I) ->
    re:replace(I,
               <<"\\n*$">>,
               <<"">>,
               [global, {return, binary}]).

quote_pids(I) ->
    re:replace(I,
               <<"(<\\d+\\.\\d+\\.\\d+>)">>,
               <<"'&'">>,
               [global, {return, binary}]).


add_dot(L0) ->
    Size = size(L0) - 1,
    case L0 of
        <<_:Size/binary, ".">> ->
            L0;
        _ ->
            <<L0/binary, ".">>
    end.

read_stdin() ->
    case io:get_line("") of
        eof ->
            ok;
        "\n" ->
            ok;
        L ->
            L0 = remove_trailing_newlines(L),
            try
                T = handle_line(L0),
                io:format("GOT LINE: ~p ~n", [T])
            catch Error:Reason ->
                io:format("~p ~p ~n", [Error, Reason]),
                io:format("~p ~n", [L0])
            end,
            read_stdin()
    end.

handle_line(L) ->
    L0 = lists:foldl(fun(F, I) -> F(I) end,
                     L,
                     [?FUNC(quote_pids), ?FUNC(add_dot)]),
    to_erlang_term(L0).

main(_) ->
    read_stdin().
