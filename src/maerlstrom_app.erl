%%%-------------------------------------------------------------------
%% @doc maerlstrom public API
%% @end
%%%-------------------------------------------------------------------

-module(maerlstrom_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    maerlstrom_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
