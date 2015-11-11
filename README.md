# IPBES


Catalogue of Assessments on Biodiversity and Exosystem Services for the Intergovernmental Platform on Biodiversity and Ecosystem Services (IPBES). [link](http://catalog.ipbes.net/)

## Setup

This is a Ruby 1.9 and Rails 3.2 project. To install you will need to have Bundler and run:

```
bundle install
```
The main dependency is Google Custom Search

### Google Custom Search

Searches are backed onto Google Custom Search (GCS). The reason for using custom search is that is it capable of indexing attachments for searching on. Many of the reports contain large PDF attachments, which CSE handles for us.
To configure GCS you will need to sign in the Google informatics account and point to [GCS page](https://cse.google.co.uk/cse/all). If you are changing the server you need to change the url in "Sites to search" tab.
Any changes to GCS id must be updated on [assessment.rb](https://github.com/unepwcmc/ipbes/blob/master/app/models/assessment.rb) model.

The downside of using it is that the index does not update immediately. If anyone asks why their newly created report isn't showing up, check to see if you can find it on the homepaging using cmd+f for the title (i.e. don't use the search). If the report is there, but not in the search results, it's probably just waiting to be indexed.
Unfortunately, there is no way to force google to index your site reliably, so you pretty much just have to wait. The lesson here? Don't use google custom search unless you really, really have to.
