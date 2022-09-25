## Mini questionnaire program 

Built using Ruby, Redis and tested with RSpec. Fully dockerised. 

## Setup 
```
docker-compose build
docker-compose run --rm app # for the questionnaire

docker-compose run --entrypoint=rspec --rm app # for all tests
```

## Notes 
- I chose Redis for its ease of use, however it does have some quirks in that it can't really store arrays as such - 
its closest equivalent is the list data type which stores all values as strings. Hence I had to map over the list
to convert each value to an integer when calculating the average score. 
- Average scores are rounded to 2 d.p. for brevity. 
- I separated out Redis to its own class (and with its own unit test) to make it easier to work with the Ruby Redis wrapper.
- I have added an option to the prompt to initiate a 'clean run' (without historical data by deleting all the Redis keys) if so required. 
- I would also have allowed the opportunity for the user to retake the questionnaire once the current run finished without having
to relaunch the app but this doesn't really simulate a real-life situation where individual users would be taking the questionnaire.
