# Mama's Recipe Box (Flatiron Phase 3 Project Backend Server)
This is the backend server for my Flatiron phase 3 project called Mama's Recipe Box. The front end React code can be found [https://github.com/kmcelhinney09/phase3-sinatra-react-frontend](https://github.com/kmcelhinney09/phase3-sinatra-react-frontend)

## Getting Started
This project is built in Ruby so you need to have Ruby installed and useable in your IDE more information on Ruby can be found at [https://www.ruby-lang.org/en/documentation/installation/](https://www.ruby-lang.org/en/documentation/installation/)

### Backend Setup

This repository has all the code needed to get the Mama's Recipe Box backend up and
running. [**Fork and clone**][fork link] this repository to get started. Then, run
`bundle install` to install the gems.

[fork link]: https://github.com/kmcelhinney09/phase-3-sinatra-react-project/fork

Before you get started run to following to create and see all of the databases.
```bash
$ rake db:migrate
```

The `app/controllers/application_controller.rb` file has all the route
handlers to go with the frontend website.

The `app/db/seeds.rb` file has the coded needed to create 11 user, recipes, ingredients, and reviews to use for development.

You can start your server with:

```console
$ rake server
```

This will run your server on port
[http://localhost:9292](http://localhost:9292).

### Frontend Setup

Make sure you [**fork and clone**][frontend fork] the frontend repository and follow the directions in the ReadMe

[frontend fork]:https://github.com/kmcelhinney09/phase3-sinatra-react-frontend/fork

## Roadmap
I plan on continuing to develop the frontend and backend for this project as time permits and grow features such as editing your user reviews, better inputting of recipes, and browsing recipes without having to log in. 

## Contributing
I welcome feedback and contributions to this project to improve it.


## License
[MIT](https://choosealicense.com/licenses/mit/)