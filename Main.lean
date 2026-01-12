import VersoBlog

import Blog
import MD4Lean

#eval MD4Lean.parse "foo *bar*"

open Verso Genre Blog Site Syntax

open Output Html Template Theme in
def theme : Theme := { Theme.default with
  primaryTemplate := do
    let postList :=
      match (← param? "posts") with
      | none => Html.empty
      | some html => {{ <h2> "Posts" </h2> }} ++ html
    let catList :=
      match (← param? (α := Post.Categories) "categories") with
      | none => Html.empty
      | some ⟨cats⟩ => {{
          <div class="category-directory">
            <h2> "Categories" </h2>
            <ul>
            {{ cats.map fun (target, cat) =>
              {{<li><a href={{target}}>{{Post.Category.name cat}}</a></li>}}
            }}
            </ul>
          </div>
        }}
    return {{
      <html>
        <head>
          <meta charset="utf-8"/>
          <meta name="viewport" content="width=device-width, initial-scale=1"/>
          <meta name="color-scheme" content="light dark"/>
          <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sakura.css/css/sakura.css" type="text/css"/>
          <link rel="preconnect" href="https://fonts.googleapis.com"/>
          <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
          <link href="https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;0,700;1,400;1,600;1,700&display=swap" rel="stylesheet"/>
          <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet"/>
          <link href="https://fonts.googleapis.com/css2?family=Charis+SIL:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet"/>
          <link href="https://fonts.googleapis.com/css2?family=Victor+Mono:wght@400&display=swap" rel="stylesheet"/>
          <link href="https://fonts.googleapis.com/css2?family=Princess+Sofia&display=swap" rel="stylesheet"/>
          <title>{{ (← param (α := String) "title") }} " — Verso "</title>
          {{← builtinHeader }}
          <link rel="stylesheet" href="/static/style.css"/>
        </head>
        <body>
          <header>
            <div class="inner-wrap">
            {{ if (← currentPath).isEmpty then .empty else
              {{ <a class="logo" href="/"><h1>"Lua Viana Reis"</h1></a> }} }}
            {{ ← topNav }}
            </div>
          </header>
          <main>
            <div class="wrap">
              {{← breadcrumbs 2}}
              {{← param "content" }}
              {{ catList }}
              {{ postList }}
            </div>
          </main>
        </body>
      </html>
    }}
  }
  |>.override #[] {
    template := do
      return {{<div class="frontpage">{{← param "content"}}</div>}},
    params := id
  }


def blog : Site := site Blog.FrontPage /
  static "static" ← "static_files"
  "about" Blog.About
  "blog" Blog.Posts with
    Blog.Posts.Welcome
    -- Blog.Posts.FirstPost
  -- "photography" Blog.Photography
  "friends" Blog.Friends

#check Blog.Posts.FibIter.«the canonical document object name».toPart

def main := blogMain theme blog
