# Bloggy for Ghost

<p align="center">
  <br>
  <img src="http://i.imgur.com/vxzThpT.png" alt="bloggy">
  <br>
</p>

![Last version](https://img.shields.io/github/tag/Kikobeats/bloggy.svg?style=flat-square)
![Ghost version](https://img.shields.io/badge/Ghost-0.7.x-brightgreen.svg?style=flat-square)
![Node version](https://img.shields.io/node/v/bloggy.svg?style=flat-square)
[![Donate](https://img.shields.io/badge/donate-paypal-blue.svg?style=flat-square)](https://paypal.me/kikobeats)

> Brand theme for Ghost.

## Introduction

**Bloggy** is a fork of [Ghost Blog](https://github.com/TryGhost/Blog) theme with the unique purpose to make easy and adaptable Ghost theme for brand/corporative/marketing purpose.

## Features

- i18n support. Currently `en_US`/`en_ES` supported.
- Google Analytics integration.
- Newsletter integration powered by Mailchimp.
- Featured and Static post views.
- Sidebar based in widgets like popular posts, featured post, social, banner,...
- Easy to hack. No limits!

## First Steps

### Installation

Enter the theme folder (`content/themes`) of your Ghost installation and paste the following command:

```bash
$ git clone https://github.com/Kikobeats/bloggy.git
```

### Setup

### DOM Selector

It's necessary that you stablish the DOM library and the version to use with the theme.

For do it, go to `Admin Panel` → `Code Injection` → `Blog Footer` and should be similar to:

```html
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
```

### i18n

**Supported languages:** `en_US`/`en_ES`

By default, the main JS file of the theme is not linked because it's depend of what language do you want to use.

For do it, the process is similar to the DOM Selector: go to `Admin Panel` → `Code Injection` → `Blog Footer`.

Now, the code to paste depend of the language that you want to use in your blog. The template of the code is:

```html
<script type="text/javascript" src="/assets/js/bloggy.#{lang}.js"></script>
```

Replacing the `#{lang}` for the supported language that you want to use.

For example, if you want to use the `en_EN` version, just add:

```html
<script type="text/javascript" src="/assets/js/bloggy.en_EN.js"></script>
```

## Development

1. Install theme dev dependencies: `npm install`.
2. setup dev environment: `gulp`.
3. Make a PR per each improvement :-).

## Related

* [Uno Zen](https://github.com/Kikobeats/uno-zen#uno-zen-for-ghost) – Minimalist and Elegant theme for Ghost.

## License

MIT © [Kiko Beats](kikobeats.com)
 
