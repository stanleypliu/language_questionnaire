FROM ruby:2.6.5

WORKDIR /questionnaire

COPY . . 

RUN gem install rspec

RUN gem install redis 

RUN gem install mock_redis

ENTRYPOINT ["ruby", "runner.rb"]
