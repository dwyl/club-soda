# Club Soda Guide
Mindful Drinking Movement - Club Soda MVP 2.0

### [Design Documents](/design)

## Why?

The Club Soda Guide has been created to help **make a world where nobody has to
feel out of place if they're not drinking**.

## Who?

The guide is for anyone who wishes not to drink, whether that's a little or all
of the time. We call this mindful drinking. This group of people we have broadly
called consumers, however there are many subsets of consumers that we will delve
into in more detail in the future.

To help provide mindful drinkers with information on low / non alcoholic drinks
and places where they can enjoy them we are also focussing on drink brand
representatives and venue managers. Not forgetting, the team at CS HQ who will
run and maintain the site.

Here are the user personas for these groups:

![Persona, Nisha the Consumer](https://user-images.githubusercontent.com/16775804/46004041-d5933300-c0a9-11e8-9c97-c7ea0ad38d9e.png "Persona, Nisha the Consumer")

![Persona, Bradley the Brand Manager](https://user-images.githubusercontent.com/16775804/46004238-49354000-c0aa-11e8-801b-858d137f6b1b.png "Persona, Bradley the Brand Manager")

![Persona, Vicky the Venue Manager](https://user-images.githubusercontent.com/16775804/46004426-cb256900-c0aa-11e8-8faa-31878125a4d4.png "Persona, Vicky the Venue Manager")

![Persona, Jussi from Club Soda](https://user-images.githubusercontent.com/16775804/46004730-7c2c0380-c0ab-11e8-96b1-267bdc416001.png "Persona, Jussi from Club Soda")

## What?

The site acts as a place of discovery for consumers to find low / non alcoholic
drinks and venues that serve them. It will also provide brands and venues with
the opportunity to connect and understand their consumers better. We hope this
will drive a community that owns the mindful drinking movement.

## User Guide

In the current iteration of the app, users can sign up and add their venue.

To sign up, visit https://club-soda-guide-staging.herokuapp.com/users/new, or click on the 'List a Venue' button on the top left of any page.

<img src="https://user-images.githubusercontent.com/8939909/46817864-c681d580-cd77-11e8-8a50-ff87fa446391.png" alt="'List a Venue' Button" width="200"/>

From there, you will see a sign up form, enabling users to sign up with an email address and add their venue and its details. After you sign up, you'll be taken to the venue's listing page.

<img width="500" alt="Sample Venue Page" src="https://user-images.githubusercontent.com/8939909/46818567-7efc4900-cd79-11e8-8287-75bafadf2155.png">

To see all venues that currently exist, you can visit https://club-soda-guide-staging.herokuapp.com/venues, where you'll see a list of all venues. From here you can click 'show' to visit the venue page, 'edit' to edit its details, or 'delete' to delete the venue listing.

<img width="500" alt="Venue listings" src="https://user-images.githubusercontent.com/8939909/46818459-32b10900-cd79-11e8-8268-a01b735c0ed2.png">

The venue types and drinks that can be added to a venue listing can be added to by visiting https://club-soda-guide-staging.herokuapp.com/venue_types/new, or https://club-soda-guide-staging.herokuapp.com/drinks/new respectively.

<img width="275" alt="New drink" src="https://user-images.githubusercontent.com/8939909/46818775-edd9a200-cd79-11e8-8dfd-c4db560d0c6c.png">

<img width="250" alt="New Venue Type" src="https://user-images.githubusercontent.com/8939909/46818794-f7fba080-cd79-11e8-8caa-f05f65becbeb.png">

You can also see a list of all venue types, and drinks on https://club-soda-guide-staging.herokuapp.com/venue_types and https://club-soda-guide-staging.herokuapp.com/drinks, where you can show, edit and delete them as with the venues. (These pages are still undergoing work so do not currently look very nice, but are functional).

## User Admin Guide

The CS team has the ability to add, edit and delete various details to do with
drinks, brands and venues on the site. At present these are not password protected.

These are the elements of the site that can be amended in this way and their
corresponding urls:
- Users `/users`
- Drinks `/drinks`
  - Drink types `/drink_types`
  - Drink style `/drink_styles`
- Brands `/brands`
- Venues `/venues`
  - Venue type `/venue_types`

Go to one of these links and you will have the option to create a new one,
view/edit an existing one or delete an old one. Like this:

![image](https://user-images.githubusercontent.com/16775804/47349854-67dc2600-d6ac-11e8-8cd8-ff634e743fd3.png)

When you add/edit a subcategory its fields will be updated in the main category
to which it belongs. E.g. If you add a new venue type it will become a new option
under venue types in the new venue form. So you could add 'pub' as a new type and
then when you create a new venue you would now have the ability to select 'pub'
as the venue type when creating your new venue.


## Importing Data

The existing data is imported through our [seeds file](priv/repo/seeds.exs).

The environment variable `IMPORT_FILES_DIR` should be the path to the directory containing the csv files (For example, if those files are hosted on AWS S3, it would be the path of the S3 bucket).

The files should be named correctly such that the format of te file matches the function that will be calling it. (That is, the brands file should be `brands.csv`, drinks `drinks.csv` and the venues `venues_1.csv`, `venues_2.csv` or `venues_3.csv`, depending on which format it is. These should be named correctly already, and as this import is only intended to be done once, shouldn't need to be changed. This documentation is just here as a guide if this import function ever needs to be extended.)