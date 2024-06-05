%%%-------------------------------------------------------------------
%% @doc maerlstrom top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(maerlstrom_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    SupFlags = #{strategy => one_for_all,
                 intensity => 0,
                 period => 1},
    ChildSpecs = [
	#{id => maerlstrom_stdin_slurper,
	  start => {maerlstrom_stdin_slurper, start_link, []},
	  restart => permanent,
	  shutdown => brutal_kill,
	  type => worker,
	  modules => [maerlstrom_stdin_slurper]}
    ],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
