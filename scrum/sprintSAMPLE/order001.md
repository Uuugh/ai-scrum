We would like to deploy to Azure in the future, but first we need a web app that runs locally.

The eventual solution will use App Service, Cosmos DB, and any required supporting services. The first version should use a SvelteKit static-site-generated single-page app, served by a Node.js process that also provides the API, with SQLite for storage.

Build a ticket management system with common ticket fields, such as dates, and statuses for unassigned, not started, in progress, completed, and cancelled.

A dashboard is essential. It should show who is doing what and support dynamic filtering, such as by person or recent work.
