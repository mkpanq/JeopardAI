require "redis"
redis = Redis.new

DEFAULT_PROMPT = "The quick brown fox jumps over the lazy dog"
DEFAULT_PROMPT_HELPER = "_ _ e;_ u _ _ _;_ _ _ _ n;f _ _;_ _ _ p _;_ v _ _;t _ _;_ _ _ y;_ _ g"

redis.setnx("generated_at", Date.today.to_formatted_s(:long))
redis.setnx("prompt", DEFAULT_PROMPT)
redis.setnx("prompt_helper", DEFAULT_PROMPT_HELPER)
