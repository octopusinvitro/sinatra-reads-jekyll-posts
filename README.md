# Markdown Spike

This is a SPIKE made as a proof of concept for a Sinatra app that reads markdown files that contain frontmatter at the top.

These files could have been produced to be used with Jekyll or they could have been produced by [prose.io](http://prose.io).

The files live in a `content/posts` directory at the root of this repo (which is not provided). You could also have other kind of files like `content/events` or `content/summaries` etc. as you need them.

Ruby **YAML** library is used to extract the frontmatter. The markdown of the file is parsed to html by the **RDiscount** gem as recommended in Sinatra's official documentation on [Markdown Templates](http://recipes.sinatrarb.com/p/views/markdown).


## Install

Clone the repo and:

```
bundle install
```

## Run the app

This is a spike, so there isn't anything fancy:

```
ruby app.rb
```

Then go to <http://localhost:3000>.


## Code

This is not the most elegant code! Don't do it like this! Use proper objects! :slightly_smiling_face:

The main page lists all the ways you can use markdown with Sinatra and the *blog* link is the one that implements reading markdown files that contain frontmatter.

Read the code in app.rb to see how the routes work.

> The bits that read the markdown files containing frontmatter are in the `/blog/` and `/blog/:slug`
