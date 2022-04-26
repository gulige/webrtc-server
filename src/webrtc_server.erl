-module(webrtc_server).

-export([
    peers/1,
    publish/2,
    publish/3,
    send/2,
    send/3
]).

peers(Room) ->
    [{PeerId, Name} || {_Pid, {Name, PeerId}} <- syn:members(scope(), Room)].

publish(Room, Event, Data) ->
    Message = webrtc_utils:text_event(Event, Data),
    syn:publish(scope(), Room, Message).

publish(Room, Event) ->
    Message = webrtc_utils:text_event(Event),
    syn:publish(scope(), Room, Message).

send(Peer, Event) ->
    {Pid, _} = syn:lookup(scope(), Peer),
    Message = webrtc_utils:text_event(Event),
    Pid ! Message,
    ok.

send(Peer, Event, Data) ->
    {Pid, _} = syn:lookup(scope(), Peer),
    Message = webrtc_utils:text_event(Event, Data),
    Pid ! Message,
    ok.

scope() ->
    case get(syn_scope) of
        undefined ->
            {ok, Value} = application:get_env(webrtc_server, syn_scope),
            put(syn_scope, Value),
            Value;
        Value -> Value
    end.

