function [Value, Timestamp, R, S] = redisXRevRange(R, stream, count)

S = 'OK';
Value = [];
Timestamp = [];

if ~strcmp(R.Status, 'open')
  S = 'ERROR - NO CONNECTION';
  return;
end

[Response, R, S] = redisCommand(R, redisCommandString(sprintf('XREVRANGE %s + - COUNT %d', stream, count)));

if Response(1) == '-'
  S = Response;
  return
end

if Response(1) ~= '*'
  S = Response;
  return
end

% response $-1 means nonexistant key
if Response(2) == '-'
  S = 'ERROR - NONEXISTANT Stream'
  return
end

a = strfind(Response, "*2");

arr_timestamp = Response(a(1):a(2)-1);
arr_msg = Response(a(2):length(Response));

cell_timestamp = redisParseBulkReply(arr_timestamp);
Timestamp = cell_timestamp{1};
Value = redisParseBulkReply(arr_msg);

