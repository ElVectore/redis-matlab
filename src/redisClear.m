function redisClear(r)
% there shouldn't be any info on the port, but if there is, let's get rid of it
if r.BytesAvailable > 0,
  fread(r, r.BytesAvailable);
end    
end

