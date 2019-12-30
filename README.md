# Pretius APEX Enhanced Modal dialog
##### Oracle APEX Dynamic action plugin v1.0
The plugin is dynamic action plugin dedicated to use with Oracle APEX 5.x chained modal pages.

Unlike to native modal page dialogs, the plugin allows to adjust every chained modal page appearance and behavior. Each time the modal page in modal dialog is loaded, the plugin adjust appearance (width, height, height in percents) and change behavior (resizable, draggable) of currently opened modal dialog.

## Preview
![Alt text](/preview.gif?raw=true "Preview")

## Table of Contents
- [License](#license)
- [Demo Application](#demo-application)
- [Features at Glance](#features-at-glance)
- [Roadmap](#roadmap)
- [Install](#install)
  - [Installation package](#installation-package)
  - [Install procedure](#install-procedure)
- [Usage guide](#usage-guide)
- [Changelog](#changelog)
- [1.0](#10)
- [About Author](#about-author)
- [About Pretius](#about-pretius)
- [Support](#support)
  - [Free support](#free-support)
  - [Paid support](#paid-support)

## License
MIT

## Demo Application
[http://apex.pretius.com/apex/f?p=105:ENHANCED_MODAL_PAGE](http://apex.pretius.com/apex/f?p=105:ENHANCED_MODAL_PAGE)

## Features at Glance
* the plugin is compatible with Oracle APEX starting from version 5.0.
* the plugin was tested under three major browsers: Internet Explorer 10+, Firefox, Chrome.
* each chained modal page attributes are applied after page in modal dialog is loaded;
* height in percent is acceptable and is computed to pixels (accoring to window size);
* modal dialgos sizes are animated;

## Roadmap
* [ ] resizing broswer window results in recalculating popup dialogs sizes given in percents;
* [ ] remembering sizes of modal dialog for re-subbmited modal page;
* [ ] support for easing jQuery functions in resizing animation;

## Install

### Installation package
1. `src/dynamic_action_plugin_pretius_apex_enhanced_modal_dialog.sql` - the plugin installation files for Oracle APEX 5.1 or higher


### Install procedure
To successfully install/update the plugin follow those steps:
1. Install the plugin file `dynamic_action_plugin_pretius_apex_enhanced_modal_dialog.sql` using Oracle APEX plugin import wizard
1. Configure application level componenets of the plugin

## Usage guide
On APEX magic page 0 (or on each modal page) create dynamic action on event Page Load and create TRUE action defined as:

* `Action` = `Pretius APEX Enhanced Modal dialog [Plug-in]`
* `Animation duration` = `500`
* `Fire on page load` = `Yes`

Save changes and test plugin in action with any created modal page.

`If you created dynamic action on APEX magic page 0 and you want to open native modal dialog set "STOP_PASM" as button REQUEST.`
`If you created dynamic action on each modal page you have to create same dynamic action on page that launches to first modal.`

## Changelog

### 1.0
Initial release

## About Author
Author            | Website                                 | Github                                       | Twitter                                       | E-mail
------------------|-----------------------------------------|----------------------------------------------|-----------------------------------------------|----------------------------------------------------
Bartosz Ostrowski | [http://ostrowskibartosz.pl](https://www.ostrowskibartosz.pl) | [@bostrowski](https://github.com/bostrowski) | [@bostrowsk1](https://twitter.com/bostrowsk1) | bostrowski@pretius.com, ostrowski.bartosz@gmail.com

## About Pretius
Pretius Sp. z o.o. Sp. K.

Address | Website | E-mail
--------|---------|-------
Przy Parku 2/2 Warsaw 02-384, Poland | [http://www.pretius.com](http://www.pretius.com) | [office@pretius.com](mailto:office@pretius.com)

## Support
Our plugins are free to use but in some cases you might need to contact us. We are willing to assist you but in certain circumstances you will be charged for our time spent on helping you. Please keep in mind we do our best to keep documentation up to date and we won't answer question for which there is explaination in documentation (at github and as help text in application builder).

All request (bug fix / change request) should be posted in Issues Tab at github repository.

### Free support
We do support the plugin in certain cases such as bug fixing and change request. If you have faced issue that might be bug please check Issues tab in github repository. In case you won't be able to find related issue please raise the issue following these rules:

* issue should contain login credentials to application at apex.oracle.com where issue is reproduced
* issue should contain steps to reproduce the issue in demo application
* issue should contain description about it's nature

### Paid support
In case you are not able to implement the plugin or you are willing to have custom implementation based on the plugin attributes (ie. custom JavaScript callbacks) we are willing to help you. Please send inquiry to apex[at]pretius.com with description what you want us to help you with. We will contact you as soon as possible with pricing and possible dates.
