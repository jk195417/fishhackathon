# Fish Hackathon 2018 高雄初賽
題目 9

# Setup

require `ruby` and `bundler`

```bash
# clone
$ git clone https://github.com/jk195417/fishhackathon.git
# install gems
$ bundle
```

set api keys at `env.yml`

```yml
# env.yml
elevation_key: 'your-google-elevation-key-here'
what_3_words_key: 'your-what-3-words-key-here'
```

# Run

```bash
$ ruby tasks/find_represent_anchors.rb
$ ruby tasks/get_what_3_words.rb
$ ruby tasks/get_elevations.rb
```

results at `represent_anchors.csv`
